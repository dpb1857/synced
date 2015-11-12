#!/bin/sh

cd $HOME

for srcdir in /home/dpb-stuff/linked-dirs /home/space/linked-dirs /mnt/shared/dpb/linked-dirs /mnt/shared/dpb-x100/linked-dirs; do
    if [ -d $srcdir ]; then
	dirs=`cd $srcdir && echo *`
	for dir in $dirs; do
	    if [ -h $dir ]; then
		points_to="`cd $dir && /bin/pwd`"
		desired="$srcdir/$dir"
		if [ $points_to = $desired ]; then
		    continue
		fi
		set -x
		rm -f $dir
		set +x
	    fi
	    if [ -d $dir ]; then
		set -x
		rmdir $dir 2>/dev/null
		set +x
	    fi
	    if [ -d $dir ]; then
		echo "***** Could not remove existing directory $dir, skipping..."
	    else
		set -x
		ln -s $srcdir/$dir $dir
		set +x
	    fi
	done
    fi
done
