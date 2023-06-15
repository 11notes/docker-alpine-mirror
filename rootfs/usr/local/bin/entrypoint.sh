#!/bin/ash
  NGINX_INCLUDE=""

  for VERSION in "$@"; do
    mkdir -p /mirror/var/${VERSION}
    VERSION_ESC=$(echo ${VERSION} | sed "s/\./\\\./")
    NGINX_INCLUDE="${NGINX_INCLUDE}location ~* /${VERSION_ESC} { access_log /var/log/nginx/access.log alpine_mirror_local if=\$alpine_mirror_log; }\n\  "
  done

  cp /nginx/etc/default.conf.tpl /nginx/etc/default.conf
  sed -i "s#\$INCLUDE#${NGINX_INCLUDE}#" /nginx/etc/default.conf

  mqtt-exec -h msg.alpinelinux.org -t rsync/rsync.alpinelinux.org/# -v -- cache mqtt -i buildozer &
  exec nginx -g 'daemon off;'