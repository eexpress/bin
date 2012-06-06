#!/bin/bash

for f in "$@"; do
#echo $f
[ -d $f ] && continue
i=`ls -i1 "$f"|cut -d' ' -f 1`
j=`find . -inum $i`
[ $j ] && echo "$i $f => $j"
done
#find -inum `ls -i1 "$1"|cut -d' ' -f 1`
#● for i in ~/Ubuntu\ One/opera/ln.config/*; do find-hardln-here.bash "$i"; done
#● find . -type f -links +1

