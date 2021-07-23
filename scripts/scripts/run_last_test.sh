#!/bin/bash

DOT=${HOME}/.last_test

if [[ -z "$1" ]] ; then
    if [[ -f $DOT ]] ; then
        source $DOT
    else
        TEST_PATTERN=cedx
    fi
else
    TEST_PATTERN=$1
fi
echo "TEST_PATTERN=$TEST_PATTERN" > $DOT

echo $TEST_PATTERN
ecn_unit_test -P --fuzzy $TEST_PATTERN
