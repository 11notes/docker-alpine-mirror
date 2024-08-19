![Banner](https://github.com/11notes/defaults/blob/main/static/img/banner.png?raw=true)

# 🏔️ Alpine - Alpine Mirror
![size](https://img.shields.io/docker/image-size/11notes/alpine-mirror/stable?color=0eb305) ![version](https://img.shields.io/docker/v/11notes/alpine-mirror/stable?color=eb7a09) ![pulls](https://img.shields.io/docker/pulls/11notes/alpine-mirror?color=2b75d6) ![stars](https://img.shields.io/docker/stars/11notes/alpine-mirror?color=e6a50e) [<img src="https://img.shields.io/badge/github-11notes-blue?logo=github">](https://github.com/11notes)

**Run your own Alpine mirror for all your Alpine installations**

# SYNOPSIS
What can I do with this? Host a local Alpine mirror. The mirror will only cache the versions you specified during start or the folders which are present in /mirror/var. All others versions will be proxied to the default CDN of Alpine.

# VOLUMES
* **/mirror/etc** - Directory of additional nginx configurations
* **/mirror/var** - Directory of all mirror data

# COMPOSE
```yaml
services:
  alpine-mirror:
    image: "11notes/alpine-mirror:stable"
    container_name: "alpine-mirror"
    command: [ "v3.19", "v3.20" ]
    ports:
      - "8080:8080"
    volumes:
      - "var:/mirror/var"
volumes:
  var:
```

# DEFAULT SETTINGS
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |
| `home` | /mirror | home directory of user docker |

# ENVIRONMENT
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | |
| `DEBUG` | Show debug information | |
| `DNS` | space separated list of DNS servers | 9.9.9.10 8.8.4.4 |

# PARENT IMAGE
* [11notes/nginx:stable](https://hub.docker.com/r/11notes/nginx)

# BUILT WITH
* [alpine mirror](https://dl-cdn.alpinelinux.org/alpine)
* [alpine](https://alpinelinux.org)

# TIPS
* Allow non-root ports < 1024 via `echo "net.ipv4.ip_unprivileged_port_start={n}" > /etc/sysctl.d/ports.conf`
* Use a reverse proxy like Traefik, Nginx to terminate TLS with a valid certificate
* Use Let’s Encrypt certificates to protect your SSL endpoints

# ElevenNotes<sup>™️</sup>
This image is provided to you at your own risk. Always make backups before updating an image to a new version. Check the changelog for breaking changes. You can find all my repositories on [github](https://github.com/11notes).
    