#!/bin/sh

# compare the two file system trees;
#
# usage: compare-tree <old-tree> <new-tree>
#

usage()
{
     echo "compare-tree <old-tree> <new-tree>"
     exit 1;
}

if [ $# -ne 2 ]
then
    usage;
fi

curDir=`pwd`
cd $curDir; cd $1; OLD_TREE=`pwd`
cd $curDir; cd $2; NEW_TREE=`pwd`

echo "Comparing $OLD_TREE to $NEW_TREE..."

cd $OLD_TREE
find . -type f -print | sort > /tmp/files.oldtree
find . -type d -print | sort > /tmp/dirs.oldtree

cd $NEW_TREE
find . -type f -print | sort > /tmp/files.newtree
find . -type d -print | sort > /tmp/dirs.newtree

# Find the removed directories;
comm -23 /tmp/dirs.oldtree /tmp/dirs.newtree > /tmp/dirs.deleted
echo "REMOVED DIRECTORIES:"
cat /tmp/dirs.deleted
echo ""

# Find the added directories;
comm -13 /tmp/dirs.oldtree /tmp/dirs.newtree > /tmp/dirs.added
echo "ADDED DIRECTORIES:"
cat /tmp/dirs.added
echo ""

##
## Remove the files in deleted directories from consideration;
##
if [ -s /tmp/dirs.deleted ]
then
    cd $OLD_TREE
    find `cat /tmp/dirs.deleted` -type f \
        \( -name \*.\[ch\] -o -name Makefile \) -print | \
        grep -v copyright.c | sort | uniq > /tmp/files.ignore
    mv /tmp/files.oldtree /tmp/xxx.$$
    comm -23 /tmp/xxx.$$ /tmp/files.ignore > /tmp/files.oldtree
    rm -f /tmp/xxx.$$
fi

##
## Remove the files in created directories from consideration;
##
if [ -s /tmp/dirs.added ]
then
    cd $NEW_TREE
    find `cat /tmp/dirs.added` -type f \
        \( -name \*.\[ch\] -o -name Makefile \) -print | \
        grep -v copyright.c | sort | uniq > /tmp/files.ignore
    mv /tmp/files.newtree /tmp/xxx.$$
    comm -23 /tmp/xxx.$$ /tmp/files.ignore > /tmp/files.newtree
    rm -f /tmp/xxx.$$
fi

##
## Figure out what files have been newly created/deleted;
##
echo "REMOVED FILES:";
comm -23 /tmp/files.oldtree /tmp/files.newtree
echo ""
echo "ADDED FILES:";
comm -13 /tmp/files.oldtree /tmp/files.newtree 
echo ""

comm -12 /tmp/files.oldtree /tmp/files.newtree > /tmp/files.common

echo "FILES THAT HAVE CHANGED:"
for file in `cat /tmp/files.common`
do
    echo "testing file $file"
    cmp $OLD_TREE/$file $NEW_TREE/$file > /dev/null 2>&1 
    if [ $? -ne 0 ]
    then
        echo $file
    fi
done

cd /tmp;
# rm -f dirs.oldtree dirs.newtree files.oldtree files.newtree
# rm -f dirs.deleted dirs.added
# rm -f files.ignore files.common
