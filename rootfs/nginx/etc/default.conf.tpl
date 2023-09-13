log_format alpine_mirror_local escape=json '{"app":"nginx","destination":"local","time":"$time_iso8601","server":{"name":"$server_name", "protocol":"$server_protocol"}, "client":{"ip":"$remote_addr", "x-forwarded-for":"$http_x_forwarded_for", "user":"$remote_user"},"request":{"method":"$request_method", "url":"$request_uri", "time":"$request_time", "status":$status}}';
log_format alpine_mirror_proxy escape=json '{"app":"nginx","destination":"remote", "time":"$time_iso8601","server":{"name":"$server_name", "protocol":"$server_protocol"}}, "client":{"ip":"$remote_addr", "x-forwarded-for":"$http_x_forwarded_for", "user":"$remote_user"},"request":{"method":"$request_method", "url":"$request_uri", "time":"$request_time", "status":$status}, "proxy":{"host":"$upstream_addr", "time":{"connect":"$upstream_connect_time", "response":"$upstream_response_time", "header":"$upstream_header_time"}, "io":{"bytes":{"sent":"$upstream_bytes_sent", "received":"$upstream_bytes_received"}}, "cache":"$upstream_cache_status", "status":"$upstream_status"}}';

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
    resolver $DNS_NAMESERVERS;
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