#!/bin/ash
  tee /nginx/etc/default.conf <<EOF
log_format alpine_mirror_proxy escape=json '{"app":"nginx","destination":"remote", "client":"\$http_x_forwarded_for", "url":"\$request_uri", "status":\$status, "time":"\$time_iso8601"}';
log_format alpine_mirror_local escape=json '{"app":"nginx","destination":"local", "client":"\$http_x_forwarded_for", "url":"\$request_uri", "status":\$status, "time":"\$time_iso8601"}';

server {
  listen 8080 default_server;
  server_name _;
  root /mirror/var;
  autoindex on;

  error_log /dev/null;
  access_log /var/log/nginx/access.log alpine_mirror_local;

  location / {
    access_log /var/log/nginx/access.log alpine_mirror_proxy;
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