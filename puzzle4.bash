#!/bin/bash

p=`pwd`
find ./ -maxdepth 3 -type d|while read d; do
cd """$p/$d"""
n=0
for i in *.JPG *.jpg ; do
	echo $i|grep "^p-2.*jpg$"
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
montage -tile 2 -geometry 666 -background none ${a[0]} ${a[1]} ${a[2]} ${a[3]} ./p-$f.jpg
/bin/rm ${a[0]} ${a[1]} ${a[2]} ${a[3]}
		n=0
	fi
done
done
