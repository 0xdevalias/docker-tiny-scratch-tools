# docker-tiny-scratch-tools

A collection of tiny tools to make life easier when creating Docker `FROM scratch` containers; by [Glenn 'devalias' Grant](http://devalias.net/) ([@_devalias](https://twitter.com/_devalias))

This makes use of [Docker's multi-stage builds](https://docs.docker.com/engine/userguide/eng-image/multistage-build/) (available since `v17.05`).

## Usage

Copy the tiny tools for the features you need into your `FROM scratch` container.

```
FROM devalias/tiny-scratch-tools AS tiny-tools
# Nothing else required here!

# If you need ca-certificates (for HTTPS/etc), then use this trick.
# If you already use another container like alpine for your build-env, you can grab them from there instead
FROM alpine:edge AS ca-certs
RUN apk add --no-cache ca-certificates
# Nothing else required here!

FROM yourfavourite/baseimage AS build-env
# Do your build environment things here

FROM scratch
COPY --from tiny-tools /sbin/chmx /sbin/chmx                                                # If you need it
COPY --from tiny-tools /sbin/su-exec /sbin/su-exec                                          # If you need it
COPY --from=ca-certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt  # If you need it
# Then copy whatever other things you need from your build-env here
```

## Sizes

```
# du -sh ./chmx
20.0K ./chmx

# du -sh /sbin/su-exec
12.0K /sbin/su-exec
```

## GitHub

* https://github.com/0xdevalias/docker-tiny-scratch-tools

## DockerHub

* https://hub.docker.com/r/devalias/tiny-scratch-tools/

## Improvements

* Fix: https://github.com/upx/upx/issues/148
* We could probably implement some other features in this binary without increasing the size much..
    * https://github.com/esmil/musl/blob/master/include/sys/stat.h
        * `chmod`, `mkdir`, etc
    * https://github.com/esmil/musl/blob/master/include/unistd.h#L51
        * `chown`, `symlink`, etc
    * etc

## Tools

* `chmx`: https://github.com/lalyos/docker-scratch-chmx
* `su-exec`: https://github.com/ncopa/su-exec
