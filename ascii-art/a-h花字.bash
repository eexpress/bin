#!/bin/bash

if [ $(($RANDOM%2)) -eq 0 ]; then 
echo $*|sed 's/./&\&#1160;/g'|ascii2uni -a D
else
echo $*|sed 's/./&\&#1161;/g'|ascii2uni -a D
fi

