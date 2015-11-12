#!/bin/sh

# XXX NOTE: this script will fail unless you ssh into www.rusa.org as root to allow
# us to connect to the host for the first time.

touch /backup/logs/rusa
exec >> /backup/logs/rusa 2>&1

set -x
date
BASE=/srv/mirror/www.rusa.org

rsync -av --rsh="sshpass -p xmogVj4b ssh" rusa@www.rusa.org:/usr/local/apache/ $BASE/usr/local/apache
rsync -av --rsh="sshpass -p xmogVj4b ssh" rusa@www.rusa.org:/usr/local/bin/ $BASE/usr/local/bin
rsync -av --rsh="sshpass -p xmogVj4b ssh" rusa@www.rusa.org:/var/www/ $BASE/var/www
rsync -av --rsh="sshpass -p xmogVj4b ssh" rusa@www.rusa.org:/etc/ $BASE/etc


/usr/local/bin/backup.sh mirror/www.rusa.org
date
