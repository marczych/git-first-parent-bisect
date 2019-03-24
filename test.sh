#!/bin/bash

function assert() {
    if [[ $1 != $2 ]]; then
        echo 'Failed!'
        exit 1
    fi
}

assert 'two words' '2'
