#!/bin/bash

[ $# -eq 0 ] && echo 水平/垂直（-v）拼接图片。自动生成montage前缀的结果文件。&& exit
if [ $1 = -v ]; then	#-v表示垂直拼接
k="w"; p=""; shift
else					#缺省水平拼接
k="h"; p="x"
fi

min=`identify -format "%$k\n" "$@"|sort|sed '/^$/d'|head -n 1`
rm /tmp/$k* >/dev/null
convert -scale $p$min "$@" /tmp/$k
montage -tile ${p}1 -geometry +0+0 -background none /tmp/$k* ./montage-$k.png
[ -f "montage-$k.png" ] && echo "montage-$k.png created!"
