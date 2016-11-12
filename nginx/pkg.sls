# Manages installation of nginx from pkg.

{% from 'nginx/map.jinja' import nginx with context %}

nginx_install:
  pkg.installed:
    - name: {{ nginx.package }}
