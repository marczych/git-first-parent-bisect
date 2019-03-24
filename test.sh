#!/bin/bash

if [[ $(./script.sh 'two words') != '2' ]]; then
    echo Failed to count words.
    exit 1
fi
