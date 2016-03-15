#!/bin/bash

cd /srv/mirror
for d in *; do
    /usr/local/bin/backup.sh mirror/$d
done
