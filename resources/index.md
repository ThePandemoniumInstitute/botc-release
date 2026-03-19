---
title: Resources
description: Check out the Blood on the Clocktower resources that The Pandemonium Institute has made available for community toolmakers to use
image: /resources/characters/bmr/tinker_g.webp
---

# Resources

As part of our [Community Created Content Policy](https://bloodontheclocktower.com/pages/community-created-content-policy), certain Blood on the Clocktower assets are available for toolmakers to use in their own projects subject to the terms of the policy. We provide current versions of these files as part of our Github `botc-release` repository, and hosted publicly on externally-linkable URLs, as listed in this document. While we try to keep the URLs as stable as possible, they might be subject to change as the game evolves. If you need absolutely static URLs, please host your own copy of those files.

## Data files

| File                                               | Purpose                                      |
| -------------------------------------------------- | -------------------------------------------- |
| [roles.json](/resources/data/roles.json)           | All released roles in a readable JSON format |
| [jinxes.json](/resources/data/jinxes.json)         | All jinxes between released characters       |
| [nightsheet.json](/resources/data/nightsheet.json) | Night order for all released characters      |

## Edition logos

Edition logos are stored under the directory <code>{{ site.url }}{{ page.dir }}editions/</code>

<ul class="character__icons">
  {% directory path: resources/editions recursive: true, include: \.webp$ %}
  <li>
    <figure>
      <img src="{{file.url}}" alt="{{file.name}}" width="100" />
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

{% icons %}
{%- if edition -%}
<h3>{{ edition }}</h3>
{%- endif -%}

<ul class="character__icons">
{% for c in characters %}
  {% for i in c.icons %}
  {% if i %}
    <li>
    <figure>
    <img loading="lazy" src="/resources/characters/{{i.path}}" width="100" />
      <figcaption>
        <a href="/resources/characters/{{i.path}}">{{i.path }}</a>
      </figcaption>
    </figure>
    </li>
  {% endif %}
  {% endfor %}

{% endfor %}
</ul>
{% endicons %}
