# :: Header
	FROM 11notes/nginx:stable

# :: Run
	USER root

	# :: prepare
		RUN set -ex; \
      mkdir -p /mirror/etc; \
      mkdir -p /mirror/var; \
			apk add --update --no-cache \
        rsync \
        mqtt-exec;

  # :: copy root filesystem changes
    ADD ./rootfs /
    RUN set -ex; chmod +x -R /usr/local/bin

	# :: docker -u 1000:1000 (no root initiative)
		RUN set -ex; \
			chown nginx:nginx -R \
				/mirror;

# :: Volumes
	VOLUME ["/mirror/etc", "/mirror/var"]

# :: Start
  USER nginx