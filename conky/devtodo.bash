#!/bin/bash

f="/home/exp/bin/conky/devtodo.txt"
cd
todo --force-colour \
|sed 's/\x1b\[0m//g' \
|sed 's/\x1b\[1m//g' \
|sed 's/\x1b\[3\(.\)m/${color\1}/g' \
|sed 's/\([0-9]\.\)\([^$]\)/\1${color7}\2/g' \
|sed 's/^\ *//g' \
> $f

echo '${color}' >> $f
