# :: Header
  FROM 11notes/nginx:stable
  ENV HEALTHCHECK_URL=/ping
  ENV APP_ROOT=/mirror

# :: Run
  USER root

  # :: prepare image
    RUN set -ex; \
      mkdir -p ${APP_ROOT}/etc; \
      mkdir -p ${APP_ROOT}/var; \
      apk add --no-cache \
        rsync; \
      apk --no-cache upgrade;

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

# :: Start
USER docker