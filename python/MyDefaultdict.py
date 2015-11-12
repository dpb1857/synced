# -*- Python -*-

from collections import defaultdict


class myDefaultDict(defaultdict):
    def __init__(self, *args, **kwargs):
	defaultdict.__init__(self, myDefaultDict, *args, **kwargs)
