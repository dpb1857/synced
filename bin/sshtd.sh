#!/bin/sh

# To launch at boot, you can put this in the root crontab:
# @reboot /usr/bin/sshtd

set -x
exec < /dev/null
exec > /dev/null 2>&1

TUNNEL_HOST=linode.donbennett.org
TUNNEL_USER=tunnel
TUNNEL_PORT=22022

# Note sshd on remote host needs 'GatewayPorts yes' to enable a remote public listener;
while true; do
    ssh $TUNNEL_HOST -l $TUNNEL_USER -R ${TUNNEL_PORT}:localhost:22 "while true; do date; sleep 60; done";
    sleep 60;
done
