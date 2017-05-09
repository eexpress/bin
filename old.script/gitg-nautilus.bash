#!/bin/bash

if [ -e $1/.git ]; then
/usr/bin/gitg $1
else
notify-send "$1 is not a git repository."
fi

