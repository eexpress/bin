#!/bin/bash

new="/tmp/findnew"
size="+2000k"
format='Audio|MPEG|ASF|Flash'

touch $new
read -p "开始监视缓冲。。视频传输完成后，按回车。"
#find ~/.opera/cache*/ -iname "opr*.tmp" -newer $new -size +1000k -printf "------\t%p\t► %Ac\t► %kK\t►" -exec file -b {} \; -exec mv {} ~ \;
find ~/.opera/cache*/ -iname "opr*.tmp" -newer $new -size $size|while read i; do file $i|egrep $format; [ $? -eq 0 ] && mv $i ~; done
find ~/.mozilla/firefox/ -iregex ".*/[0-9A-F]*" -newer $new -size $size|while read i; do file $i|egrep $format; [ $? -eq 0 ] && mv $i ~; done
rm $new
if [ $1 ]; then mkdir "$1"; mv ~/opr*.tmp "$1/"; echo "视频已经复制到目录 \"$1\"。"; 
else echo "视频已经复制到家目录。"; fi
