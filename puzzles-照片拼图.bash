#!/bin/bash

cd `dirname "$1"`
f=`exif -m -t 0x9003 "$1"`
echo $f|grep '^20'
if [ $? -eq 1 ]; then
f="noexif-"`date '+%Y:%m:%d-%H:%M:%S'`
else
f=`echo $f|sed 's/\ /-/g'`
fi

s=`identify -format "%wx%h" "$1"`
x=`echo $s|cut -dx -f1`
y=`echo $s|cut -dx -f2`
echo -e "$1 ---->\t$f\t$s"
if [ $x -gt $y ]; then
p=0.99; s=400
else
p=1.5; s=300
fi
t=`echo "sqrt($#)+$p"|bc -l`
t=`echo $t|cut -d. -f1`
#t=`printf %d $t`
echo -e "\e[34m输出：$f\t文件：$#\t缩放宽度：$s\t列数：$t\e[0m"

rm /tmp/4in1*
convert -scale $s "$@" /tmp/4in1
montage -tile $t -geometry +0+0 -background none /tmp/4in1* ./p-$f.jpg
eog "./p-$f.jpg"
zenity --question --title=删除 --text="是否 $# 个删除文件"
[ $? -eq 0 ] && echo "删除。。。" && rm "$@"

