#!/bin/bash

p=`pwd`
echo "扫描 $p 多级子目录，将jpg图片拼接成2x2的图片。"
echo "确认操作，按回车键。按其他键取消。"
read -s -n 1 y
[[ $y != '' ]] && exit

find ./ -maxdepth 4 -type d|while read d; do
cd """$p/$d"""
echo "------------$p/$d------------"
n=0
for i in *.JPG *.jpg ; do
	echo $i|grep "^p-.*jpg$"
	[ $? == 0 ] && break
	a[$n]=$i
	((n++))
	if ((n>3)); then
		echo ${a[0]}-${a[1]}-${a[2]}-${a[3]}
		f=`exif -m -t 0x9003 "${a[0]}"`
		echo $f|grep '^20'
		if [ $? -eq 1 ]; then
		f="noexif-"`date '+%Y-%m-%d_%H-%M-%S'`
		else
		f=`echo $f|sed 's/\ /_/g'|sed 's/:/-/g'`
		fi
montage -tile 2 -geometry 666 -background none "${a[0]}" "${a[1]}" "${a[2]}" "${a[3]}" "./p-$f.jpg"
/bin/rm "${a[0]}" "${a[1]}" "${a[2]}" "${a[3]}"
		n=0
	fi
done
echo "------------END------------"
done
