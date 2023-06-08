# :: Header
	FROM 11notes/nginx:stable

# :: Run
	USER root

  # :: update image
    RUN set -ex; \
      apk update; \
      apk upgrade;

	# :: prepare image
		RUN set -ex; \
      mkdir -p /mirror/etc; \
      mkdir -p /mirror/var; \
			apk add --update --no-cache \
        rsync \
        mqtt-exec;

  # :: copy root filesystem changes and add execution rights to init scripts
    COPY ./rootfs /
    RUN set -ex; \
      chmod +x -R /usr/local/bin

  # :: change home path for existing user and set correct permission
    RUN set -ex; \
      usermod -d /mirror docker; \
      chown -R 1000:1000 \
        /mirror;

# :: Volumes
	VOLUME ["/mirror/etc", "/mirror/var"]

# :: Start
  USER docker