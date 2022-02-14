#!/bin/bash

[ $# -eq 0 ] && echo 水平/垂直（-v）拼接图片。自动生成montage前缀的结果文件。-d会删除原始文件。参数必须在文件名前面。 && exit

out="h"; p="x"	#缺省水平拼接
delete=false	#缺省不删除原始文件
while getopts "vd" opt; do
	case $opt in
		v) out="w"; p="";;	#垂直拼接
		d) delete=true;;
	esac
done
shift $(($OPTIND - 1)) 	#参数只能在文件的前面，否则$@会包含参数
# OPTIND is set to the index of the first non-option argument
direct=$out

#输出文件自动增加序号
if [ -f "montage-$out.png" ]; then
	n=0
	while [[ -f "montage-$out$n.png" ]]; do
		((n++))
	done
	out=$out$n
fi

min=`identify -format "%$direct\n" "$@"|sort -n|sed '/^$/d'|head -n 1`
echo min $direct size is $min
rm /tmp/$out* >/dev/null
n=0; for i in "$@"; do
convert -scale $p$min "$i" /tmp/$out$n
((n++))
done

[[ "$delete" == true ]] && echo rm "$@" && rm "$@"
montage -tile ${p}1 -geometry +0+0 -background none /tmp/$out* ./montage-$out.png
[ -f "montage-$out.png" ] && echo "montage-$out.png created!"
