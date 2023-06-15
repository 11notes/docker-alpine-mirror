log_format alpine_mirror_proxy escape=json '{"app":"nginx","destination":"remote", "client":"$remote_addr", "url":"$request_uri", "status":$status, "time":"$time_iso8601"}';
log_format alpine_mirror_local escape=json '{"app":"nginx","destination":"local", "client":"$remote_addr", "url":"$request_uri", "status":$status, "time":"$time_iso8601"}';

map $request $alpine_mirror_log {
    ~*/v[0-9]+ 1;
    default 0;
}

server {
  listen 8080 default_server;
  server_name _;
  root /mirror/var;
  autoindex on;

  error_log /dev/null;

  location / {
    access_log /var/log/nginx/access.log alpine_mirror_proxy if=$alpine_mirror_log;
    resolver 208.67.222.222 208.67.220.220;
    proxy_pass http://dl-cdn.alpinelinux.org/alpine$request_uri;
  } 

  location /ping {
    return 200;
  }

  location /favicon.ico {
    root /nginx/www;
    try_files $uri favicon.ico;
  }

  $INCLUDE

  include /mirror/etc/*.conf;
}