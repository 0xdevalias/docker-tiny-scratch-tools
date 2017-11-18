FROM alpine:edge AS build-env
RUN apk add --no-cache build-base gcc abuild binutils upx su-exec
WORKDIR /chmx
ADD https://raw.githubusercontent.com/lalyos/docker-scratch-chmx/master/chmx.c .
RUN gcc -static -s -o chmx chmx.c
# RUN upx --best --ultra-brute chmx -ochmx.upx    # See: https://github.com/upx/upx/issues/148

FROM scratch
# COPY --from=build-env /chmx/chmx.upx /sbin/chmx # See: https://github.com/upx/upx/issues/148
COPY --from=build-env /chmx/chmx /sbin/chmx
COPY --from=build-env /sbin/su-exec /sbin/su-exec
