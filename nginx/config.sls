{% from 'nginx/map.jinja' import nginx with context %}

nginx_log_dir:
  file.directory:
    - name: /var/log/nginx
    - user: {{ nginx.user }}
    - group: {{ nginx.user }}

nginx_config:
  file.managed:
    - name: {{ nginx.config_directory }}/nginx.conf
    - source: salt://nginx/files/nginx.conf
    - template: jinja
    - context:
        config: {{ nginx.config | yaml() }}

{% if nginx.ssl_enabled %}
{%- set dhparam_file = salt['file.join'](nginx.config_directory, 'dhparam.pem') -%}
nginx_dhparam:
  cmd.run:
    - name: openssl dhparam -out {{ dhparam_file }} {{ nginx.ssl_dhparam_bits }}
    - creates: {{ dhparam_file }}
{% endif %}

nginx_confd:
  file.directory:
    - name: /usr/local/etc/nginx/conf.d

{% if nginx.ssl_enabled %}
nginx_ssl_conf:
  file.managed:
    - name: /usr/local/etc/nginx/conf.d/ssl.conf
    - source: salt://nginx/files/ssl.conf
    - template: jinja
    - context:
        dhparam_file: {{ dhparam_file }}
{% endif %}
