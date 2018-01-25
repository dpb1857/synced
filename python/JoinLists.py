#!/usr/bin/env python

# pylint: disable=missing-docstring
# pylint: disable=invalid-name

from itertools import chain, filterfalse, zip_longest

def joinlists(a, b):

    ret = []
    ia = iter(a)
    ib = iter(b)

    try:
        while True:
            ret.append(next(ia))
            ret.append(next(ib))
    except StopIteration:
        pass

    for i in chain(ia, ib):
        ret.append(i)

    return ret

def joinlists2(a, b):
    return list(filterfalse(lambda x: x is None, chain.from_iterable(zip_longest(a, b))))


def main():
    print(joinlists2(list(range(4)), list(range(5, 7))))
    print(joinlists2(list(range(4)), list(range(5, 15))))


if __name__ == "__main__":
    main()
