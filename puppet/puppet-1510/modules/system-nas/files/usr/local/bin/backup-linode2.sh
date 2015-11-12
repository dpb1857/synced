#!/bin/sh

# XXX NOTE: this script will fail unless you ssh into the server as root to allow
# us to connect to the host for the first time.

touch /backup/logs/linode2
exec >> /backup/logs/linode2 2>&1

set -x
date
BASE=/srv/mirror/linode2.donbennett.org

rsync -av --delete-after --exclude=scratch linode2.donbennett.org:/home $BASE

/usr/local/bin/backup.sh mirror/linode2.donbennett.org
date
