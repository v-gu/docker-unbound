#!/usr/bin/env sh

# generate basic config
cat >$APP_DIR/unbound.conf <<-EOF
server:
  verbosity: $VERBOSITY
  port: $PORT

  interface: $INTERFACE
  access-control: 127.0.0.0/8 allow
  access-control: 10.0.0.0/8 allow
  access-control: 172.16.0.0/12 allow
  access-control: 192.168.0.0/16 allow

  cache-min-ttl: ${CACHE_MIN_TTL}
  cache-max-ttl: ${CACHE_MAX_TTL}
  prefetch: ${PREFETCH}

remote-control:
  control-enable: yes
  control-interface: $REMOTE_CONTROL_INTERFACE
  control-port: $REMOTE_CONTROL_PORT
  control-use-cert: no

EOF

# add default forward zone
if [ -n "$DEFAULT_FORWARD_ADDRS" ]; then
    cat >>$APP_DIR/unbound.conf <<-EOF
forward-zone:
  name: "."
EOF
    for i in $DEFAULT_FORWARD_ADDRS; do
        cat >>$APP_DIR/unbound.conf <<-EOF
  forward-addr: $i
EOF
    done
fi

# add static forward zones
if [ -n "$FORWARDS" ]; then
    for i in "$FORWARDS"; do
        domain="${i%%|*}"
        upstream="${i##*|}"

        cat >>$APP_DIR/unbound.conf <<-EOF
forward-zone:
  name: $domain
  forward-addr: ${upstream}
EOF
    done
fi

exec /usr/sbin/unbound -dd
