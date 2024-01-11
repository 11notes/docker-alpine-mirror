#!/bin/ash
  if [ -z "${1}" ]; then
    log-json info "starting alpine mirror"
    MIRROR_LOCATIONS=""
    DNS=${DNS:-"9.9.9.9 149.112.112.112"}

    for VERSION in "$@"; do
      mkdir -p ${APP_ROOT}/var/${VERSION}
      VERSION_ESC=$(echo ${VERSION} | sed "s/\./\\\./")
      MIRROR_LOCATIONS="${MIRROR_LOCATIONS}location ~* /${VERSION_ESC} { access_log /var/log/nginx/access.log alpine_mirror_local if=\$alpine_mirror_log; }\n\  "
    done

    cp /etc/mirror.conf /nginx/etc/default.conf
    sed -i "s#\$INCLUDE#${MIRROR_LOCATIONS}#" /nginx/etc/default.conf
    sed -i "s#\$DNS#${DNS}#" /nginx/etc/default.conf

    HEALTHCHECK_URL="http://localhost:8080/ping"

    set -- "nginx" \
      -g \
      'daemon off;'
  fi

  exec "$@"