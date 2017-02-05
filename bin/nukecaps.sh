#!/bin/bash

exec > /tmp/nukecaps.log 2>&1
set -x
sleep 3
/usr/bin/setxkbmap -option ctrl:nocaps
