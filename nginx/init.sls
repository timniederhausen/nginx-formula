include:
  - nginx.config
  - nginx.service
  - nginx.servers

extend:
  nginx_service:
    service:
      - watch:
        - file: nginx_config
      - require:
        - file: nginx_config
  nginx_config:
    file:
      - require:
        - pkg: nginx_install
