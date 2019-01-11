#!/bin/bash

cd "$(dirname "$0")"
d=`pwd`
for i in `ls -A|grep '^\.'`; do
# 路径中，+表示斜杠，=表示空格
l=`echo $i|sed 's.+./.g; s.=.\\\\ .g'`
cmd="rm ~/$l; ln -sf $d/$i ~/$l"
echo $cmd
eval $cmd
done
#find . -maxdepth 3 -type l -exec rm {} \;
