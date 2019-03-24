#!/bin/bash

if [[ $(./script.sh '') != '0' ]]; then
    echo Failed to count zero words.
    exit 1
fi

if [[ $(./script.sh 'two words') != '2' ]]; then
    echo Failed to count two words.
    exit 1
fi

if [[ $(./script.sh 'three words here') != '3' ]]; then
    echo Failed to count three words.
    exit 1
fi
