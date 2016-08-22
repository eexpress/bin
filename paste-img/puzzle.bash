#!/bin/bash

[ $# -gt 16 ] && echo "select less than 16 pictures." && exit
cd "`dirname "$1"`"
f=`exif -m -t 0x9003 "${1#file://}"`
echo $f|grep '^20'
if [ $? -eq 1 ]; then
f="noexif-"`date '+%Y-%m-%d_%H-%M-%S'`
else
f=`echo $f|sed 's/\ /_/g'|sed 's/:/-/g'`
fi

aw=(0 1 1 1 2 2 2 3 3 3 4 4 4 4 4 4 4)
ah=(0 1 2 3 2 3 3 4 4 4 4 4 4 5 5 5 4)
i=`identify -format "%wx%h" "$1"`
w=`echo $i|cut -dx -f1`
h=`echo $i|cut -dx -f2`
if [ $w -gt $h ]; then
t=${aw[$#]}
s=800
else
t=${ah[$#]}
s=600
fi
echo -e "\e[34m输出：$f\t文件：$#\t缩放宽度：$s\t列数：$t\e[0m"

l=`basename $0`
l=${l%%.*}
montage -tile $t -geometry $s -background none "$@" ./p-$f.jpg
eog "./p-$f.jpg"
zenity --question --title=删除 --text="是否删除 $# 个文件并保留拼图结果"
[ $? -eq 0 ] && echo "删除。。。" && for i in "$@"; do j=${i#file://}; echo $j>>/tmp/$l.log; rm "$j"; done || rm "./p-$f.jpg"

