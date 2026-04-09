module BotcRelease
  class Icon < Struct.new(
    :path,
    :edition,
    :role_id,
    :role,
    :alignment,
    keyword_init: true
  )
    REGEX =
      /^
        (?<edition>.*)
        #{File::SEPARATOR}
        (?<role_id>.*?)
        (_(?<alignment>[ge]))?.webp
      $/x

    def self.from_path(path)
      match = path.match(REGEX)
      role = Data.roles[match[:role_id]]

      new(
        path: path,
        role: role,
        **match.named_captures.transform_keys(&:to_sym)
      )
    end

    def team
      role["team"] if role
    end

    def role_alignment_order
      # The `role_id` check is for the generic icons which don't appear in the
      # roles data, but still have a different default alignment.
      if team == "minion" || team == "demon" || role_id == "minion" ||
           role_id == "demon"
        [nil, "e", "g"]
      else
        [nil, "g", "e"]
      end
    end

    def sort_key
      role_alignment_order.index(alignment) || -1
    end

    def <=>(other)
      self.sort_key <=> other.sort_key
    end

    def to_liquid
      to_h.transform_keys(&:to_s)
    end
  end

  class Character < Struct.new(:role_id, :icons, keyword_init: true)
    TEAM_ORDER = %w[townsfolk outsider minion demon traveller fabled loric]

    def role
      Data.roles[role_id]
    end

    def team
      role["team"] if role
    end

    def sort_key
      [TEAM_ORDER.index(team) || -1, role_id]
    end

    def <=>(other)
      self.sort_key <=> other.sort_key
    end

    def to_liquid
      to_h.transform_keys(&:to_s).merge("role" => role)
    end
  end

  module Data
    EDITIONS = {
      "tb" => "Trouble Brewing",
      "snv" => "Sects and Violets",
      "bmr" => "Bad Moon Rising",
      "carousel" => "Carousel",
      "loric" => "Loric",
      "fabled" => "Fabled"
    }
    ROLES_PATH = "resources/data/roles.json"

    def self.roles
      @roles ||=
        begin
          data = JSON.parse(File.read(File.expand_path(ROLES_PATH)))

          index_by(data) { |role| role["id"] }
        end
    end

    def self.index_by(array, &block)
      if block_given?
        result = {}
        array.each { |elem| result[block.call(elem)] = elem }
        result
      else
        array.to_enum(:index_by) { array.size if array.respond_to?(:size) }
      end
    end
  end

  class IconsTag < Liquid::Block
    def initialize(tag_name, markup, parse_context)
      @args = [tag_name, markup, parse_context]

      @attributes = {}

      markup.scan(Liquid::TagAttributes) do |key, value|
        @attributes[key] = value
      end

      @root = @attributes["root"] || "resources/characters"

      super
    end

    def render(context)
      dir = Pathname.new(site_directory(context, @root))

      relative_path = ->(path) do
        Pathname.new(path).relative_path_from(dir).to_s
      end

      edition_icons =
        Dir
          .glob(File.join(dir, "**/*.webp"))
          .map { |path| BotcRelease::Icon.from_path(relative_path.call(path)) }
          .group_by(&:edition)
          .sort_by { |e, _| Data::EDITIONS[e] || "" }

      context
        .stack do
          edition_icons.map do |edition, edition_icons|
            characters =
              edition_icons
                .group_by(&:role_id)
                .map do |role_id, role_icons|
                  Character.new(role_id: role_id, icons: role_icons.sort)
                end

            context["directory"] = edition == "." ? nil : edition
            context["edition"] = Data::EDITIONS[edition]
            context["characters"] = characters.sort

            render_children(context)
          end
        end
        .join("\n")
    end

    def site_directory(context, path)
      source_dir = context.registers[:site].source
      listed_dir = File.expand_path(File.join(source_dir, path))

      unless listed_dir.include?(source_dir)
        raise Liquid::ArgumentError.new "Listed directory '#{listed_dir}' cannot be out of jekyll root"
      end

      return listed_dir
    end

    def render_children(context)
      nodelist.map do |n|
        if n.respond_to? :render
          n.render(context)
        else
          n
        end
      end
    end
  end
end

Liquid::Template.register_tag("icons", BotcRelease::IconsTag)
