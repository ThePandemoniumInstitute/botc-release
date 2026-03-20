module BotcRelease
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
    TEAM_ORDER = %w[fabled loric townsfolk outsider minion demon traveller]

    def self.roles
      @roles ||=
        begin
          data = JSON.parse(File.read(File.expand_path(ROLES_PATH)))

          index_by(data) { |role| "#{role["edition"]}/#{role["id"]}" }
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

      roles = Data.roles

      relative_path = ->(path) do
        Pathname.new(path).relative_path_from(dir).to_s
      end

      icons_by_character =
        Dir
          .glob(File.join(dir, "**/*.webp"))
          .map { |path| relative_path.call(path) }
          .group_by { |path| path.sub(/(_[eg])?\.webp$/, "") }

      # Link each path to the corresponding character data, so we can group by character type
      character_icons =
        icons_by_character
          .map do |path, icons|
            mapped_icons =
              icons.each_with_object({}) do |icon, map|
                character = File.basename(icon).match(/(?:_([eg]))?.webp/)
                map[character[1]] = { "path" => icon }
              end

            {
              "path" => path,
              "icons" => mapped_icons.values_at(nil, "e", "g"),
              "label" =>
                roles.dig(path, "name") || File.basename(path).capitalize,
              "team" => roles.dig(path, "team"),
              "edition" => File.dirname(path),
              "sort_key" => [
                Data::TEAM_ORDER.index(roles.dig(path, "team")) || -1,
                path
              ]
            }
          end
          .sort_by { |c| [c.dig("character", "team") || "", c["path"]] }

      context
        .stack do
          character_icons
            .group_by { |c| c["edition"] }
            .sort_by { |e, _| Data::EDITIONS[e] || "" }
            .map do |edition, characters|
              context["directory"] = edition == "." ? nil : edition
              context["edition"] = Data::EDITIONS[edition]
              context["characters"] = characters.sort_by { |c| c["sort_key"] }
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
