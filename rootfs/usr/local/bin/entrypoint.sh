#!/bin/ash
  if [ ! -z "${1}" ]; then
    MIRROR_LOCATIONS=""
    DNS=${DNS:-"9.9.9.10 8.8.4.4"}

    for VERSION in "$@"; do
      mkdir -p ${APP_ROOT}/var/${VERSION}
      elevenLogJSON info "alpine version ${VERSION} will be cached locally"
      VERSION_ESC=$(echo ${VERSION} | sed "s/\./\\\./")
      MIRROR_LOCATIONS="${MIRROR_LOCATIONS}location ~* /${VERSION_ESC} { access_log /var/log/nginx/access.log alpine_mirror_local if=\$alpine_mirror_log; }\n\  "
    done

    cp /etc/nginx/.default/nginx.conf /nginx/etc/default.conf
    sed -i "s#\$INCLUDE#${MIRROR_LOCATIONS}#" /nginx/etc/default.conf
    sed -i "s#\$DNS#${DNS}#" /nginx/etc/default.conf

    elevenLogJSON info "starting mqtt listener for dynamic sync events"
    mqtt-exec -h "msg.alpinelinux.org" -t "rsync/rsync.alpinelinux.org/#" -- /usr/local/bin/cache sync mqtt &

    elevenLogJSON info "starting ${APP_NAME}"
    set -- "nginx" \
      -g \
      'daemon off;'
  fi

  exec "$@"