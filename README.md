# Alpine :: Mirror
Run an Alpine Mirror based on Alpine Linux. Small, lightweight, secure and fast.

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

## Parent
* [11notes/nginx:stable](https://github.com/11notes/docker-nginx)

## Built with
* [Alpine Linux Mirror](https://dl-cdn.alpinelinux.org/alpine/)
* [Alpine Linux](https://alpinelinux.org/)

## Tips
* Don't bind to ports < 1024 (requires root), use NAT/reverse proxy
* [Permanent Stroage](https://github.com/11notes/alpine-docker-netshare) - Module to store permanent container data via NFS/CIFS and more