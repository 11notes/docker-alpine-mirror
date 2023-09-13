#!/bin/ash
  NGINX_INCLUDE=""
  if [ -z "${DNS_NAMESERVERS}" ]; then DNS_NAMESERVERS="208.67.222.222 208.67.220.220"; fi

  for VERSION in "$@"; do
    mkdir -p /mirror/var/${VERSION}
    VERSION_ESC=$(echo ${VERSION} | sed "s/\./\\\./")
    NGINX_INCLUDE="${NGINX_INCLUDE}location ~* /${VERSION_ESC} { access_log /var/log/nginx/access.log alpine_mirror_local if=\$alpine_mirror_log; }\n\  "
  done

  cp /nginx/etc/default.conf.tpl /nginx/etc/default.conf
  sed -i "s#\$INCLUDE#${NGINX_INCLUDE}#" /nginx/etc/default.conf
  sed -i "s#\$DNS_NAMESERVERS#${DNS_NAMESERVERS}#" /nginx/etc/default.conf

  exec nginx -g 'daemon off;'