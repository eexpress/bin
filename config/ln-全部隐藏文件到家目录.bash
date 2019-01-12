#!/bin/bash

cd "$(dirname "$0")"
d=`pwd`
for i in `ls -A|grep '^\.'`; do
if [[ $i =~ '.swp' ]]; then continue; fi
# 路径中，+表示斜杠，=表示空格，\后面的是注释，全删除。
l=`echo $i|sed 's.+./.g; s.=.\\\\ .g'`
#l=`echo $i|sed 's/\\.*//; s.+./.g; s.=.\\\\ .g'`
cmd="rm -r ~/$l; ln -sf $d/$i ~/$l"
#echo $cmd
printf "%24s\t-->\t%s\n" "~/$l" $d/$i
eval $cmd
done
#find . -maxdepth 3 -type l -exec rm {} \;
