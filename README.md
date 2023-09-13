# Alpine :: Mirror
Run an Alpine Mirror based on Alpine Linux. Small, lightweight, secure and fast 🏔️

The mirror will only cache the versions you specified during start or the folders which are present in /mirror/var. All others versions will be proxies to the default CDN.

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
| `home` | /mirror | home directory of user docker |

## Environment
| Parameter | Value | Default |
| --- | --- | --- |
| `DNS_NAMESERVERS` | space separated list of DNS servers | 208.67.222.222 208.67.220.220 |

## Use
```shell
docker exec mirror cache sync
```
This will start the caching of all versions present in /mirror/var. You can call this in a regular interval or listen to the MQTT events on msg.alpinelinux.org.

```shell
docker exec mirror cache size
```
Will output the size in GB that you will sync from the CDN.

## Parent
* [11notes/nginx:stable](https://github.com/11notes/docker-nginx)

## Built with
* [Alpine Linux Mirror](https://dl-cdn.alpinelinux.org/alpine)
* [Alpine Linux](https://alpinelinux.org)