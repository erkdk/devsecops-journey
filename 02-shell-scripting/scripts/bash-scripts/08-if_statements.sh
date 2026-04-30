#!/bin/bash

# simple if statement
a='10'
if [ $a -eq '10' ]; then
        echo "OneZero"
fi

# if else statement
n=2
if [ $((n%2)) -eq 0 ]; then
        echo "Even"
else
        echo "Odd"
fi

# set -x is used to print each line commands, helpful for debuging

# if elif else statement
x=1
if [ $x -lt 0 ]; then
        echo "Negative"
elif [ $x -gt 0 ]; then
        echo "Positive"
else
        echo "Zero"
fi

