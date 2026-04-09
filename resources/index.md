---
title: Resources
description: Check out the Blood on the Clocktower resources that The Pandemonium Institute has made available for community toolmakers to use
image: /resources/characters/bmr/tinker_g.webp
---

# Resources

As part of our [Community Created Content Policy](https://bloodontheclocktower.com/pages/community-created-content-policy), certain Blood on the Clocktower assets are available for toolmakers to use in their own projects subject to the terms of the policy. We provide current versions of these files as part of our Github `botc-release` repository, and hosted publicly on externally-linkable URLs, as listed in this document. While we try to keep the URLs as stable as possible, they might be subject to change as the game evolves. If you need absolutely static URLs, please host your own copy of those files.

## Community Created Content logos

Projects using official assets are asked to display one of the Community Created Content (CCC) logos on their project to clearly identify their content as non-TPI content.

The CCC logos are stored under the directory <code>{{ site.url }}{{ page.dir }}community/</code>

<ul class="toolmaker_icons">
{% directory path: resources/community recursive: true, include: \.png$ %}
<li>
  <figure>
    <img loading="lazy" src="{{file.url}}" alt="{{file.name}}" />
    <figcaption>
      <a href="{{file.url}}"
        >{{file.url | replace_first: "/resources/community/", "" }}</a
      >
    </figcaption>
  </figure>
</li>
{% enddirectory %}
</ul>

## Data files

| File                                               | Purpose                                      |
| -------------------------------------------------- | -------------------------------------------- |
| [roles.json](/resources/data/roles.json)           | All released roles in a readable JSON format |
| [jinxes.json](/resources/data/jinxes.json)         | All jinxes between released characters       |
| [nightsheet.json](/resources/data/nightsheet.json) | Night order for all released characters      |

## Edition logos

Edition logos are stored under the directory <code>{{ site.url }}{{ page.dir }}editions/</code>

<ul class="toolmaker_icons">
  {% directory path: resources/editions recursive: true, include: \.webp$ %}
  <li>
    <figure>
      <img loading="lazy" src="{{file.url}}" alt="{{file.name}}" width="100" />
      <figcaption>
        <a href="{{file.url}}"
          >{{file.url | replace_first: "/resources/editions/", "" }}</a
        >
      </figcaption>
    </figure>
  </li>
  {% enddirectory %}
</ul>

## Character icons

Character icons are stored under the directory <code>{{ site.url }}{{ page.dir }}characters/</code>

These paths follow a deterministic format based on the information in the roles datafile:

* `{edition}/{id}_{alignment}.webp` for good (`g`) or evil (`e`) aligned icons
* `{edition}/{id}.webp` for unaligned icons

Click to toggle between different variants of the icons where relevant.

{% icons %}
{%- if edition -%}
### {{ edition }}
{%- endif -%}

<ul class="toolmaker_icons character__icons">
{% for c in characters %}
  <li id="icon-{{ c.role_id }}" data-selected-index="0">
  {% if c.icons.size > 1 %}
    <div class="variants">
    {% for i in c.icons %}
      <button class="alignment--{{i.alignment | default: "n"}}">{{ i.alignment | default: "n" }}</button>
    {% endfor %}
    </div>
  {% endif %}

  {% for i in c.icons %}
    <figure data-index="{{ forloop.index0 }}">
      <img loading="lazy" src="/resources/characters/{{i.path}}" width="100" height="100" />
      <figcaption>
        <a href="/resources/characters/{{i.path}}">{{i.path }}</a>
      </figcaption>
    </figure>
  {% endfor %}
  </li>

{% endfor %}
</ul>
{% endicons %}

<script>
document.addEventListener("DOMContentLoaded", function () {
  document
    .querySelectorAll("ul.character__icons li:has(.variants)")
    .forEach((iconList) => {
      iconList.addEventListener("click", (event) => {
        const variants =
          event.currentTarget.querySelectorAll(".variants button");

        let newIndex;

        if (event.target.tagName === "IMG") {
          const selectedIndex = Number(
            event.currentTarget.getAttribute("data-selected-index"),
          );
          newIndex = (selectedIndex + 1) % variants.length;
        } else if (event.target.tagName === "BUTTON") {
          newIndex = Array.from(variants).indexOf(event.target);
        }

        if (newIndex !== undefined) {
          event.currentTarget.setAttribute("data-selected-index", newIndex);
        }
      });
    });
});

</script>
