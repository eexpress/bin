#!/bin/bash

p=`pwd`
echo "扫描 $p 多级子目录，将jpg图片拼接成2x2的图片。"
echo "确认操作，按回车键。按其他键取消。"
read -s -n 1 y; [[ $y != '' ]] && exit

find ./ -maxdepth 4 -type d|while read d; do
	cd """$p/$d"""
	echo "-------$p/$d-------"
	n=0
#    shopt -s nullglob extglob
#    for i in *.@(jpg|JPG); do
	for i in *.jpg *.JPG; do
		[[ "$i" =~ ^p-.*jpg$ ]] && continue
		a[$n]=$i
		((n++))
		if ((n>3)); then
			f=`exif -m -t 0x9003 "${a[0]}"`
			if [[ "$f" =~ ^20 ]]; then
				f="noexif-"`date '+%Y-%m-%d_%H-%M-%S'`
			else
				f=${f// /_}; f=${f//:/-};
			fi
			echo "${a[0]}-${a[1]}-${a[2]}-${a[3]} -> p-$f.jpg"
			montage -tile 2 -geometry 666 -background none "${a[0]}" "${a[1]}" "${a[2]}" "${a[3]}" "p-$f.jpg"
			/bin/rm "${a[0]}" "${a[1]}" "${a[2]}" "${a[3]}"
#            /bin/rm ${a[@]} #数组的扩展，有空格问题
			n=0
		fi
	done
done
