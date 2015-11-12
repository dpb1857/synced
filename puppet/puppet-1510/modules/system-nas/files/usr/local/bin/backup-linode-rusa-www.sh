#!/bin/sh

# XXX NOTE: this script will fail unless you ssh into www.rusa.org as root to allow
# us to connect to the host for the first time.

touch /backup/logs/linode-rusa-www
exec >> /backup/logs/linode-rusa-www 2>&1

set -x
date
BASE=/srv/mirror/linode-www.rusa.org

# rsync -av git@www.rusa.org:/usr/share/nginx/gdbm/ $BASE/gdbm

/usr/local/bin/backup.sh mirror/linode-www.rusa.org
date
