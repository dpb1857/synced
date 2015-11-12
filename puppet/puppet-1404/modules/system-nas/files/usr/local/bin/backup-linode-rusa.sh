#!/bin/sh

# XXX NOTE: this script will fail unless you ssh into www.rusa.org as root to allow
# us to connect to the host for the first time.

touch /backup/logs/linode-rusa
exec >> /backup/logs/linode-rusa 2>&1

set -x
date
BASE=/srv/mirror/linode.rusa.org

rsync -av git@linode.rusa.org:/home/git/ $BASE/git

/usr/local/bin/backup.sh mirror/linode.rusa.org
date
