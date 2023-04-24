#!/bin/ash
  tee /nginx/etc/default.conf <<EOF
log_format proxy escape=json '{"destination":"remote", "client":"\$http_x_forwarded_for", "url":"\$request_uri", "status":\$status}';
log_format local escape=json '{"destination":"local", "client":"\$http_x_forwarded_for", "url":"\$request_uri", "status":\$status}';

server {
  listen 8080 default_server;
  server_name _;
  root /mirror/var;
  autoindex on;

  error_log off;
  access_log /var/log/nginx/access.log local;

  location / {
    access_log /var/log/nginx/access.log proxy;
    resolver 208.67.222.222 208.67.220.220;
    proxy_pass http://dl-cdn.alpinelinux.org/alpine\$request_uri;
  } 

  location /favicon.ico {
    try_files \$uri favicon.ico;
  }

  %INCLUDE%

  include /mirror/etc/*.conf;
}
EOF

  NGINX_INCLUDE=""

  for VERSION in "$@"; do
    mkdir -p /mirror/var/${VERSION}
    VERSION_ESC=$(echo ${VERSION} | sed "s/\./\\\./")
    NGINX_INCLUDE="${NGINX_INCLUDE}location ~* /${VERSION_ESC} {}\n\  "
  done

  sed -i "s#%INCLUDE%#${NGINX_INCLUDE}#" /nginx/etc/default.conf

  mqtt-exec -h msg.alpinelinux.org -t rsync/rsync.alpinelinux.org/# -v -- cache mqtt -i buildozer &
  exec nginx -g 'daemon off;'