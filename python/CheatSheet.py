#!/usr/bin/env python3


# random
import random

# repeatable
random.seed(0)

# Note both ends are inclusive;
# a <= N <= b
random.randint(0, 9)

# Random element from a non-empty sequence
random.choice(seq)

random.shuffle(seq)
