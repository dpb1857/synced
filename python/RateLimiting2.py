#!/usr/bin/env python3

# Find pylint codes at: http://pylint-messages.wikidot.com/all-codes
# pylint: disable=line-too-long
# pylint: disable=invalid-name
# pylint: disable=missing-docstring
# pylint: disable=too-few-public-methods

import time


def ratelimit(qps):
    def decorator(f):
        base_second = int(time.time())
        counter = 0

        def wrapper(*args):
            nonlocal base_second, counter

            this_second = int(time.time())
            if this_second > base_second:
                base_second = this_second
                counter = 1
                return f(*args)

            elif counter <= qps:
                counter += 1
                return f(*args)

            else:
                raise Exception

        return wrapper

    return decorator

@ratelimit(3)
def hello():
    print("Hello")

def main():
    hello()
    hello()

    time.sleep(2)

    for _ in range(5):
        hello()

main()
