#!/usr/bin/env python3

# Find pylint codes at: http://pylint-messages.wikidot.com/all-codes
# pylint: disable=line-too-long
# pylint: disable=invalid-name
# pylint: disable=missing-docstring
# pylint: disable=too-few-public-methods

import time

def ratelimit(qps):
    def decorator(f):
        # ring buffer to hold timestamps
        recent = [0.0] * qps
        indx = 0

        def wrapper(*args):
            nonlocal indx
            now = time.time()
            if recent[indx] + 1 < now:
                # If recent[indx] is old enough, we can insert the new timestamp
                # and advance the pointer;
                recent[indx] = now
                indx = (indx+1) % qps
                print("timestamps:", recent)
                return f(*args)

            raise Exception

        return wrapper
    return decorator

def main():
    @ratelimit(3)
    def hello():
        print("Hello!")

    hello()
    hello()
    time.sleep(2)

    for _ in range(5):
        hello()

if __name__ == "__main__":
    main()
