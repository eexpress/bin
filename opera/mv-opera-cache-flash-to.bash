#!/bin/bash

d="/home/exp/下载/$1"
mkdir $d
find ~/.opera/cache*/ -size +1500k -exec mv {} $d/ \;
cd $d
rename 's/$/.mp4/' *
echo "---------------"
ls

