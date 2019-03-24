#!/bin/bash

set -euo pipefail

# Counts the number of words in the first argument.

awk '{$1=$1;print}' <<< "$(wc -w <<< "$1")"
