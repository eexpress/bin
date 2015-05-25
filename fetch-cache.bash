#!/bin/bash

new="/tmp/findnew"
size="+2000k"
format='Audio|MPEG|ASF|Flash'

cd
touch $new
read -p "开始监视缓冲。。视频传输完成后，按回车。"
find ~/.cache/opera-developer/Cache/ -iname "f_*" -newer $new -size $size|while read i; do file $i|egrep $format; [ $? -eq 0 ] && mv $i ~/`basename -z $i`.flv; done
#find ~/.opera/cache*/ -iname "opr*.tmp" -newer $new -size $size|while read i; do file $i|egrep $format; [ $? -eq 0 ] && mv $i ~/`basename -z $i`.flv; done
#find ~/.cache/mozilla/firefox/ -iregex ".*/[0-9A-F]*" -newer $new -size $size|while read i; do file $i|egrep $format; [ $? -eq 0 ] && mv $i ~/`basename -z $i`.flv; done
rm $new
if [ $1 ]; then mkdir "$1"; mv ~/*.flv "$1/"; echo "视频已经复制到目录 \"$1\"。"; 
else echo "视频已经复制到家目录。"; fi
