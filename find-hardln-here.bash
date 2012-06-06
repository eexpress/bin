#!/bin/bash

for f in "$@"; do
#echo $f
[ -d $f ] && continue
i=`ls -i1 "$f"|cut -d' ' -f 1`
j=`find . -inum $i`
[ $j ] && echo "$i $f => $j"
done
#find -inum `ls -i1 "$1"|cut -d' ' -f 1`
#● find . -type f -links +1
#● find-hardln-here.bash ~/Ubuntu\ One/opera/ln.config/*
