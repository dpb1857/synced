#!/bin/sh

d=`/bin/pwd`
while [ ! -d $d/.git ]; do
    d=`cd $d/.. && /bin/pwd`
    if [ "$d" = "/" ]; then
        echo "Could not location .git directory." 1>&2
        exit 1
    fi
done

set -x
cp post-checkout $d/hooks
set +x
