# Alpine :: Mirror
Run an Alpine Mirror based on Alpine Linux. Small, lightweight, secure and fast 🏔️

The mirror will only cache the versions you specified during start or the folders which are present in /mirror/var.

## Volumes
* **/mirror/etc** - Directory of additional nginx configurations
* **/mirror/var** - Directory of all mirror data

## Run
```shell
docker run --name mirror \
  -v ../etc:/mirror/etc \
  -v ../var:/mirror/var \
  -d 11notes/alpine-mirror:[tag] \
    v3.16 \
    v3.17 \
    v3.18
```

## Defaults
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |

## Use
```shell
docker exec mirror cache
```
This will start the caching of all versions present in /mirror/var. You can call this in a regular interval or listen to the MQTT events on msg.alpinelinux.org.

## Parent
* [11notes/nginx:stable](https://github.com/11notes/docker-nginx)

## Built with
* [Alpine Linux Mirror](https://dl-cdn.alpinelinux.org/alpine)
* [Alpine Linux](https://alpinelinux.org)