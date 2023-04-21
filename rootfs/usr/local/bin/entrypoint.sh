#!/bin/ash
  NGINX_INCLUDE=""

  for VERSION in "$@"; do
    mkdir -p /nginx/www/${VERSION}
    VERSION_ESC=$(echo ${VERSION} | sed "s/\./\\\./")
    NGINX_INCLUDE="${NGINX_INCLUDE}location ~* /${VERSION_ESC} {}\n\  "
  done

  sed -i "s#%INCLUDE%#${NGINX_INCLUDE}#" /nginx/etc/default.conf

  mqtt-exec -h msg.alpinelinux.org -t rsync/rsync.alpinelinux.org/# -v -- cache mqtt -i buildozer &
  exec nginx -g 'daemon off;'