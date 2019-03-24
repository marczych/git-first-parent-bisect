#!/bin/python

import pipefail

# Counts the number of words in the first argument.

with open(sys.stdin) as stdin:
    print(len(stdin.read.split(' ')))
