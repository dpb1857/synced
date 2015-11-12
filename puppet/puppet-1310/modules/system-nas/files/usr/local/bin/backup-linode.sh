#!/bin/sh

# XXX NOTE: this script will fail unless you ssh into the server as root to allow
# us to connect to the host for the first time.

touch /backup/logs/linode
exec >> /backup/logs/linode 2>&1

set -x
date
BASE=/srv/mirror/linode.donbennett.org

rsync -av --delete-after linode.donbennett.org:/etc $BASE
rsync -av --delete-after linode.donbennett.org:/root $BASE
rsync -av --delete-after --exclude=scratch linode.donbennett.org:/home $BASE

/usr/local/bin/backup.sh mirror/linode.donbennett.org
date
