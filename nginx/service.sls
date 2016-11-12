# Manages the nginx service.

{% from 'nginx/map.jinja' import nginx with context %}
{% set service_function = {True:'running', False:'dead'}.get(nginx.service_enabled) %}

include:
  - nginx.pkg

nginx_service:
  service.{{ service_function }}:
    - name: {{ nginx.service }}
    - enable: {{ nginx.service_enabled }}
    - require:
      - sls: nginx.pkg
    - listen:
      - pkg: nginx_install
