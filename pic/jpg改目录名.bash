#!/bin/bash

#echo "$*" >~/parameter
#整理当前目录下的jpg图片名字，按照目录名字排序。
[ -z "$1" ] && echo "指定目录或文件不存在。" && exit;
[ -f "$1" ] && dir=`dirname """$1"""`;
[ -d "$1" ] && dir=$1;
echo 参数：$1
echo 目录：$dir
[ -z "$dir" ] && echo "目录不存在。" && exit;

cd "$dir"
#ls -F|grep /
#[ $? == 0 ] && echo "不是末级目录，不进行操作，退出。" && exit;
dir=`pwd`
prefix=${dir##*\/}
echo 前缀：$prefix
#pwd
#[ $? == 0 ] && echo "目录名为单字母的，退出。" && exit;
#w=`xclip -o`
prefix=`zenity  --entry --text="将目录 $dir 中的图片使用如下文件名前缀进行整理。" --entry-text="$prefix" --title="整理图片"|tail -n 1`
echo 确定的前缀：● $prefix ●
[ -z "$prefix" ] && echo "前缀为空。" && exit;
#exit 0;

num=0
for i in *.jpg *.JPG *.jpeg *.JPEG
do
if [ -e "$i" ]; then	#发现*.JPG等没有的列表被输出，屏蔽下。
#符合规则的文件不需要修改
	if [ `expr match "$i" "${prefix}-[0-9]*.jpg$"` != 0 ]; then
		tmp=${i#"$prefix"-}
		tmp=${tmp%".jpg"}
#		echo ${tmp} ----------------------
		if [ "$tmp" -le "$num" ]; then
		echo $i 符合规则，不修改。当前排序已到 $num。
		continue
		fi
	fi
	result="$prefix"-$num.jpg
#防止覆盖已有文件
	while [ -e "$result" ]
	do
		((num++))
		result="$prefix-$num.jpg"
	done
#	i=`echo $i | sed 's/\ /\\\ /g'`
#	result=`echo $result | sed 's/\ /\\\ /g'`
	# | sed 's/\(/\\\(/g' | sed 's/\)/\\\)/g'
	echo ============= $i '->' $result
	mv "$i" "$result"
	((num++))
fi
done
