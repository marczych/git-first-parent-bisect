#!/bin/bash

set -euo pipefail

if [[ $# == 0 || $1 == "-h" || $1 == "--help" ]]; then
    echo "Usage: $0 string"
    exit 0
fi

# Counts the number of words in the first argument.

awk '{$1=$1;print}' <<< "$(wc -w <<< "$1")"
