#!/bin/bash

#~ 把+号开头的文件目录，当作隐藏文件链接到家目录。
cd "$(dirname "$0")"
d=`pwd`
printf "%70s\n" | tr ' ' '='
for target in `\ls|grep '^+'`; do
	# 路径中，+表示斜杠，=表示空格。第一个+表示'~/.'。
	link=`echo $target|sed 's|+|/|g; s|=|\\\\ |g; s|^/|~/.|'`
	cmd="rm -r $link; ln -sf $d/$target $link"
	#~ echo $cmd
	eval $cmd

	#~ printf "%24s\t-->\t%s\n" $link $d/$target	# 格式化输出
	eval "\ls --color=always -l $link"	# 变量中带~号，就不执行扩展。只能用eval当字符串处理。
	printf "%70s\n" | tr ' ' '-'
done

#~ 备份：
#~ mv ~/.config/geany/colorschemes ~/bin/config/+config+geany+colorschemes

#find . -maxdepth 3 -type l -exec rm {} \;
