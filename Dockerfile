#
# Dockerfile for unbound
#

FROM alpine
MAINTAINER Vincent.Gu <g@v-io.co>

ENV UDP_PORT   53
ENV TCP_PORT   53
ENV REMOTE_CONTROL_PORT 8953

EXPOSE $UDP_PORT/udp
EXPOSE $TCP_PORT/tcp
EXPOSE $REMOTE_CONTROL_PORT/tcp

# build software stack
ENV DEP unbound
RUN set -ex \
    && apk --update --no-cache add $DEP \
    && rm -rf /var/cache/apk/*

# copy-in files
ADD unbound.conf /etc/unbound/

ENTRYPOINT ["/usr/sbin/unbound", "-dd"]
