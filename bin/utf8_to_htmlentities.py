#!/usr/bin/env python
# -*- coding: utf-8 -*-

import htmlentitydefs
import sys

# adapted from http://mail.python.org/pipermail/python-list/2007-May/442893.html

def unicode2htmlentities(u):

   entities = list()

   for c in u:
       next_ch = c
       if ord(c) >= 128:
           try:
               next_ch = u"&%s;" % htmlentitydefs.codepoint2name[ord(c)]
           except:
               pass

       entities.append(next_ch)

   return ''.join(entities)

def encode(str):
    str = unicode2htmlentities(str)
    str = str.encode("ascii", "xmlcharrefreplace")
    return str

if __name__ == "__main__":
    
    # print encode(u"This é is a test")
    str = sys.stdin.read().decode("utf-8")
    print encode(str)
