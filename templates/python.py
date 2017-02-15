#!/usr/bin/env python

"""
Module comment
"""

# Find pylint codes at: http://pylint-messages.wikidot.com/all-codes
# pylint: disable=line-too-long
# pylint: disable=invalid-name

def main():
    "Main function body"
    import argparse

    parser = argparse.ArgumentParser(description="myscript")
    parser.add_argument("values", metavar="values", type=int, nargs="+", help="values")
    parser.add_argument("--xflag", "-x", action="store_true")
    parser.add_argument("--count", "-c", type=int)
    parser.add_argument("--file", "-f")

    args = parser.parse_args()
    print "args:", args

if __name__ == "__main__":
    main()
