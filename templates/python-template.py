#!/usr/bin/env python3

"""
Module comment
"""

# Find pylint codes at: http://pylint-messages.wikidot.com/all-codes
# pylint: disable=line-too-long
# pylint: disable=invalid-name
# pylint: disable=missing-docstring
# pylint: disable=too-few-public-methods

import logging

Help_message = """
This is help text.
"""

def interact():

    def get_command():
        line = input("> ")
        cmd, *rest = line.split()
        return cmd, rest

    while True:
        cmd, _rest = get_command()

        if cmd == "help":
            print(Help_message)
        elif cmd in ("q", "quit"):
            return
        else:
            print("unknown command, type 'help'for help.")


def main():
    "Main function body"
    import argparse

    parser = argparse.ArgumentParser(description="myscript")
    parser.add_argument("values", metavar="values", type=int, nargs="+", help="values")
    parser.add_argument("--xflag", "-x", action="store_true")
    parser.add_argument("--count", "-c", type=int)
    parser.add_argument("--file", "-f")
    parser.add_argument("--verbose", "-v", action="store_true")
    parser.add_argument("--quiet", "-q", action="store_true")

    args = parser.parse_args()

    if args.quiet:
        log_level = logging.ERROR
    elif args.verbose:
        log_level = logging.DEBUG
    else:
        log_level = logging.INFO

    logging.basicConfig(level=log_level)
    logging.debug("args: %s", args)

if __name__ == "__main__":
    main()