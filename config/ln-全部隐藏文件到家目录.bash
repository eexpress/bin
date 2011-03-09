#!/bin/bash

d=`pwd`
for i in `ls -A|grep '^\.'`; do
#ln -sf $i
cmd="ln -sf $d/$i ~/$i"
echo $cmd
eval $cmd
done
