#
# Dockerfile for unbound
#

FROM alpine
MAINTAINER Vincent.Gu <g@v-io.co>

ENV APP_DIR                     /srv/unbound
ENV INTERFACE                   127.0.0.1
ENV PORT                        53
ENV SSL_PORT                    853
ENV REMOTE_CONTROL_INTERFACE    127.0.0.1
ENV REMOTE_CONTROL_PORT         8953
ENV VERBOSITY                   1
ENV FORWARDS                    ""

EXPOSE $PORT/udp
EXPOSE $PORT/tcp
EXPOSE $SSL_PORT/tcp
EXPOSE $REMOTE_CONTROL_PORT/tcp

ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

# build software stack
ENV DEP unbound
RUN set -ex \
    && apk --update --no-cache add $DEP \
    && rm -rf /var/cache/apk/* \
    && ln -s /etc/unbound /srv/unbound
WORKDIR $APP_DIR

ENTRYPOINT ["/entrypoint.sh"]
