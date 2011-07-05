#!/bin/bash

d=`pwd`
for i in `ls -A|grep '^\.'`; do
#echo "--------------$i"
#ln -sf $i
l=`echo $i|sed 's/+/\//g'`
cmd="ln -sf $d/$i ~/$l"
echo $cmd
eval $cmd
done
find . -maxdepth 2 -type l -exec rm {} \;
