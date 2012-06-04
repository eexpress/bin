#!/bin/bash

mvln() {
[ -d $i ] && return
echo ----$i----
l=`readlink -f $i`
f=`pwd`/`basename $i`
cp "$i" .
ln -f "$f" "$l"
}

if [ $# -gt 0 ]; then
for i in $@; do mvln; done
else
while read i; do mvln; done
fi

