#!/bin/bash

#~ 将重要配置文件集中，以便用 git 来管理，原始位置建立软链接。

cd "$(dirname "$0")"
d=`pwd`
printf "%70s\n" | tr ' ' '='

#~ ---------没有参数，把+号开头的文件目录恢复到家目录-------------------
if [ $# -eq 0 ]; then	# 。
	for target in `\ls|grep '^+'`; do
		# 路径中，+表示斜杠，=表示空格。第一个+表示'~/.'。
		link=`echo $target|sed 's|+|/|g; s|=|\\\\ |g; s|^/|~/.|'`
		path=`dirname $link | sed "s|^~|$HOME|"`
		[ -d $path ] || mkdir -p $path
		#~ if [ ! -d "$path" ]; then mkdir -p "$path"; fi
		cmd="rm -r $link; ln -sf $d/$target $link"
		eval $cmd
		eval "\ls --color=always -l $link"	# 变量中带~号，就不执行扩展。只能用eval当字符串处理。
		printf "%70s\n" | tr ' ' '-'
	done
	exit
fi
#~ --------------参数只有list时，列出全部备份的文件--------------------
if [ $# -eq 1 ] && [ $1 == "list" ]; then
	eval "\ls -F -1|grep '^+'|sed 's|+|/|g; s|=|\\\\ |g; s|/|~/.|'"
	printf "%70s\n" | tr ' ' '-'
	exit
fi
#~ --------------读取全部参数，是文件目录就备份-------------------------
for f in $@; do
	if [ -e $f ]; then
		cf=`echo $f|sed "s|${HOME}/.|+|; s|/|+|g; s|\ |=|g"`
		cmd="mv $f $cf; ln -sf $d/$cf $f"
		eval $cmd
		eval "\ls --color=always -l $f"
		printf "%70s\n" | tr ' ' '-'
	else
		echo $f 没有找到。
	fi
done
