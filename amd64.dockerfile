# :: Header
	FROM 11notes/nginx:stable

# :: Run
	USER root

	# :: prepare
		RUN set -ex; \
			apk add --update --no-cache \
        rsync \
        mqtt-exec;

    # :: copy root filesystem changes
      ADD --chown=1000:1000 ./rootfs /
      RUN set -ex; chmod +x -R /usr/local/bin

  USER nginx