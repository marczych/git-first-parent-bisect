#!/bin/bash

function assert() {
    if [[ $1 != $2 ]]; then
        echo 'Failed!'
        exit 1
    fi
}

assert '' '0'
assert 'two words' '2'
assert 'three words here' '3'
