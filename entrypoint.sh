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

remote-control:
  control-enable: yes
  control-interface: $REMOTE_CONTROL_INTERFACE
  control-port: $REMOTE_CONTROL_PORT
  control-use-cert: no

EOF

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
