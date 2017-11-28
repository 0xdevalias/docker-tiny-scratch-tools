FROM devalias/upx:devel AS upx

FROM alpine:edge AS build-env
RUN apk add --no-cache build-base gcc abuild binutils su-exec
# Note: we're using the devel branch of UPX as the current release doesn't handle 'position independent main programs' well
# See: https://github.com/upx/upx/issues/148
COPY --from=upx /usr/bin/upx /usr/bin/upx
WORKDIR /chmx
ADD https://raw.githubusercontent.com/lalyos/docker-scratch-chmx/master/chmx.c .
RUN gcc -static -s -o chmx chmx.c
RUN upx --best --ultra-brute chmx -ochmx.upx

FROM scratch
COPY --from=build-env /chmx/chmx.upx /sbin/chmx
COPY --from=build-env /sbin/su-exec /sbin/su-exec
