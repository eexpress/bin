#!/bin/bash

d=`pwd`
for i in `ls -A|grep '^\.'`; do
#ln -sf $i
l=`echo $i|sed 's/+/\//g'`
cmd="ln -sf $d/$i ~/$l"
echo $cmd
eval $cmd
done
