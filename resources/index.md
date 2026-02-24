---
title: Resources
---

## Character icons

You can download these icons directly from the repository, or link to them remotely with the appropriate path added to the base URL: <code>{{ site.url }}{{ page.dir }}icons</code>. These paths follow a deterministic format:

* `/{edition}/{id}_{alignment}.webp` for good (`g`) or evil (`e`) aligned icons
* `/{edition}/{id}.webp` for unaligned icons

<ul class="icons">
  {% directory path: resources/icons recursive: true, include: \.webp$ %}
  <li>
    <figure>
      <img src="{{file.url}}" alt="{{file.name}}" width="100" height="100" />
      <figcaption>
        <a href="{{file.url }}"
          >{{file.url | replace_first: "/resources/icons", "" }}</a
        >
      </figcaption>
    </figure>
  </li>
  {% enddirectory %}
</ul>
