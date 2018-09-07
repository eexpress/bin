#!/bin/bash

[ -z $1 ] && echo "need photo file name." && exit
f1="VeraSansYuanTi-Bold"
f2="经典繁颜体-Regular"
ss=`exif $1|grep -m 1 -o '[0-9:]\{10,\}'|sed 's/:/-/g'`
cmd="convert $1 -fill grey -background none -font $f2 -pointsize 18 -gravity SouthEast -draw 'text 10,10 \" ${ss}\"' -fill '#F4A862' -stroke black -draw 'text 12,12 \" ${ss}\"' $1.jpg"
echo $cmd
eval $cmd
feh $1.jpg
# -box '#00770080' rgb+透明，放在draw前面
