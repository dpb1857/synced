#!/usr/bin/python

import os
import sys
import filecmp


def Dirlist(dir):
    dirlist = ["."]
    Dirlist_2(dirlist, dir, ".")
    dirlist.sort()
    return dirlist

def Dirlist_2(dirlist, base, dir):
    try:
	dir_entries = os.listdir(os.path.join(base, dir))
    except:
	return

    for file in dir_entries:
	full_file = os.path.join(base, dir, file)
	if os.path.islink(full_file):
	    continue
	elif os.path.isdir(full_file):
	    relative_dir = os.path.join(dir, file)
	    dirlist.append(relative_dir)
	    Dirlist_2(dirlist, base, relative_dir)

def Filelist(base, dirlist):
    filelist = []
    Filelist_2(filelist, base, dirlist)
    filelist.sort()
    return filelist

def Filelist_2(filelist, base, dirlist):
    for dir in dirlist:
	full_dir = os.path.join(base, dir)
	try:
	    dir_entries = os.listdir(full_dir)
	except:
	    continue
	
	for file in dir_entries:
	    full_file = os.path.join(full_dir, file)
	    if not os.path.isfile(full_file):
		continue
	    relative_file = os.path.join(dir, file)
	    filelist.append(relative_file)

def Comm(list1, list2):
    left= []
    right = []
    both = []

    i1=0
    i2=0

    while i1<len(list1) or i2<len(list2):
	if i1 == len(list1):
	    right += list2[i2:]
	    break
	elif i2 == len(list2):
	    left += list1[i1:]
	    break
	
	if list1[i1] == list2[i2]:
	    both.append(list1[i1])
	    i1 += 1
	    i2 += 1
	elif list1[i1] < list2[i2]:
	    left.append(list1[i1])
	    i1 += 1
	else: # list1[i1} > list2[i2]
	    right.append(list2[i2])
	    i2 += 1
	   
    return left, right, both

def ModifiedFiles(dir1, dir2, filelist):
    modified = []

    for file in filelist:
	file1 = os.path.join(dir1, file)
	file2 = os.path.join(dir2, file)

	modified_flag = 1
	try:
	    if filecmp.cmp(file1, file2):
		modified_flag = 0
	except:
	    pass

	if modified_flag:
	    modified.append(file)

    return modified

def Usage():
    print "compare-tree.py <old-tree> <new-tree>"
    sys.exit(1)

#
# Main script body
#

if len(sys.argv) != 3:
    Usage()

old_tree, new_tree = tuple(sys.argv[1:])

old_dirs = Dirlist(old_tree)
new_dirs = Dirlist(new_tree)

left_dirs, right_dirs, both_dirs = Comm(old_dirs, new_dirs)

old_files = Filelist(old_tree, both_dirs)
new_files = Filelist(new_tree, right_dirs+both_dirs)

left_files, right_files, both_files = Comm(old_files, new_files)
modified_files = ModifiedFiles(old_tree, new_tree, both_files)

if left_dirs:
    print "SECTION deleted directories:"
    for dir in left_dirs:
	print dir

if left_files:
    print "SECTION Deleted files:"
    for file in left_files:
	print file

if right_dirs:
    print "SECTION Added directories:"
    for dir in right_dirs:
	print dir

if right_files:
    print "SECTION Added files:"
    for file in right_files:
	print file

if modified_files:
    print "SECTION Modified files:"
    for file in modified_files:
	print file
