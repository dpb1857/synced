#!/bin/sh
set -x
exec < /dev/null
exec > /home/dpb/sshtunnel.log 2>&1

TUNNEL_HOST=linode.donbennett.org
TUNNEL_USER=dpb
TUNNEL_PORT=22022

# Note sshd on remote host needs 'GatewayPorts yes' to enable a remote public listener;
ROUTER_PORT=22080

while true; do
    ssh $TUNNEL_HOST -l $TUNNEL_USER -R ${TUNNEL_PORT}:localhost:22 -R 0.0.0.0:${ROUTER_PORT}:192.168.2.1:80 "while true; do date; sleep 60; done";
    sleep 60;
done
