#!/usr/bin/env python3

# Find pylint codes at: http://pylint-messages.wikidot.com/all-codes
# pylint: disable=line-too-long
# pylint: disable=invalid-name
# pylint: disable=missing-docstring
# pylint: disable=too-few-public-methods

import itertools
import random

##########
########## Random
##########

seq = range(10)

# repeatable
random.seed(0)

# Note both ends are inclusive;
# a <= N <= b
random.randint(0, 9)

# Random element from a non-empty sequence
random.choice(seq)

# Shuffle a sequence
random.shuffle(seq)

# Select N random ints in a range
random.sample(range(1000000), 50)

##########
########## Lists
##########

l1 = [0, 1, 2]
l2 = [5, 6, 7]

# Append;
l1.append(3)

# As a stack;
list.pop()
list.pop(0) # pop from position 0;

# Add another list;
list.extend(iter(l2))

# Flatten list of lists;
list_of_lists = [[1, 2], [3, 4]]
flattened_list = [y for x in list_of_lists for y in x]

##########
########## Itertools
##########

l1 = [0, 1, 2]
l2 = [5, 6, 7, 8]

# join iterables;
itertools.chain(l1, l2) # , ...)

# Zip iterables together;
list(zip(l1, l2)) # [(0, 5), (1, 6), (2, 7)]

# Zip the longest;
list(itertools.zip_longest(l1, l2)) # [(0, 5), (1, 6), (2, 7), (None, 8)]

# Map a function using iterator tuples as arguments
list(itertools.starmap(lambda x,y: x*y, zip(l1, l2))) # [0, 6, 14]

# Cartesian product
list(itertools.product(l1, l2))
# [(0, 5), (0, 6), (0, 7), (0, 8), (1, 5), (1, 6), (1, 7), (1, 8),
#  (2, 5), (2, 6), (2, 7), (2, 8)]

# Permutations
list(itertools.permutations(l1))
# [(0, 1, 2), (0, 2, 1), (1, 0, 2), (1, 2, 0), (2, 0, 1), (2, 1, 0)]

# Combinations
list(itertools.combinations(l1, 2))
# [(0, 1), (0, 2), (1, 2)]
