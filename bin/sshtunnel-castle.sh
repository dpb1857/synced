#!/bin/sh

TUNNEL_HOST=linode.donbennett.org
TUNNEL_USER=dpb
TUNNEL_PORT=22022
# TUNNEL_HOST=newnewlegacynew.prod.quixey.com
# TUNNEL_USER=don

while true; do
    ssh $TUNNEL_HOST -l $TUNNEL_USER -R ${TUNNEL_PORT}:localhost:22 "while true; do date; sleep 60; done";
    sleep 60;
done