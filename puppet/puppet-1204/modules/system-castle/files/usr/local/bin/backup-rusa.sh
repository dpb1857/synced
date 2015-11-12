#!/bin/sh

BASE=/mnt/backup

rsync -av --rsh="sshpass -p xmogVj4b ssh" rusa@www.rusa.org:/usr/local/bin/ $BASE/daily.0/www.rusa.org/usr/local/bin
rsync -av --rsh="sshpass -p xmogVj4b ssh" rusa@www.rusa.org:/var/www/ $BASE/daily.0/www.rusa.org/var/www
rsync -av --rsh="sshpass -p xmogVj4b ssh" rusa@www.rusa.org:/etc/ $BASE/daily.0/www.rusa.org/etc

