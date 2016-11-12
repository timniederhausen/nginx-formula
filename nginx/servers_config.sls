# Manages the configuration of virtual host files.

{% from 'nginx/map.jinja' import nginx with context %}
{% set server_states = [] %}

# Makes sure the sites directory exists.
nginx_server_sites_dir:
  file.directory:
    - name: {{ nginx.config_directory }}/sites

# Manage server config files.
{% for server, settings in nginx.servers.items() %}
{% if settings.config != None %}
{% set conf_state_id = 'server_conf_' ~ loop.index0 %}
{% set config_path = salt['file.join'](nginx.config_directory, 'sites', server + '.conf') %}
{{ conf_state_id }}:
{% if settings.enabled %}
  file.managed:
    - name: {{ config_path }}
    - source: salt://nginx/files/server.conf
    - template: jinja
    - context:
        config: {{ settings.config | yaml() }}
    - replace: {{ settings.get('overwrite', True) }}
{% else %}
  file.absent:
    - name: {{ config_path }}
{% endif %}
{% do server_states.append(conf_state_id) %}
{% endif %}
{% endfor %}
