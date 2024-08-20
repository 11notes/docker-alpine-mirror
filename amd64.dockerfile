# :: Util
  FROM alpine as util

  RUN set -ex; \
    apk add --no-cache \
      git; \
    git clone https://github.com/11notes/util.git;

# :: Header
  FROM 11notes/nginx:stable
  COPY --from=util /util/linux/shell/elevenLogJSON /usr/local/bin
  ENV APP_ROOT=/mirror
  ENV APP_NAME="alpine-mirror"
  ENV HEALTHCHECK_URL="http://localhost:8080/ping"

# :: Run
  USER root

  # :: prepare image
    RUN set -ex; \
      mkdir -p ${APP_ROOT}/etc; \
      mkdir -p ${APP_ROOT}/var; \
      apk add --no-cache --update \
        rsync \
        mqtt-exec; \
      apk --no-cache upgrade; \
      rm -rf /nginx/etc/default.conf;

  # :: copy root filesystem changes and add execution rights to init scripts
    COPY --chown=1000:1000 ./rootfs /
    RUN set -ex; \
      chmod +x -R /usr/local/bin;

  # :: change home path for existing user and set correct permission
    RUN set -ex; \
      usermod -d ${APP_ROOT} docker; \
      chown -R 1000:1000 \
        ${APP_ROOT};

# :: Volumes
  VOLUME ["${APP_ROOT}/etc", "${APP_ROOT}/var"]

# :: Ports
  EXPOSE 8080/tcp

# :: Start
  USER docker