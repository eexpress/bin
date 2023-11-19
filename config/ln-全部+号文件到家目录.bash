#!/bin/bash

#~ 把+号开头的文件目录，当作隐藏文件链接到家目录。
cd "$(dirname "$0")"
d=`pwd`
printf "%70s\n" | tr ' ' '='
if [ $# -eq 0 ]; then	# 没有参数，执行恢复操作。
	for target in `\ls|grep '^+'`; do
		# 路径中，+表示斜杠，=表示空格。第一个+表示'~/.'。
		link=`echo $target|sed 's|+|/|g; s|=|\\\\ |g; s|^/|~/.|'`
		path=`dirname $link | sed "s|^~|$HOME|"`
		[ -d $path ] || mkdir -p $path
		#~ if [ ! -d "$path" ]; then mkdir -p "$path"; fi
		cmd="rm -r $link; ln -sf $d/$target $link"
		#~ echo $cmd
		eval $cmd

		#~ printf "%24s\t-->\t%s\n" $link $d/$target	# 格式化输出
		eval "\ls --color=always -l $link"	# 变量中带~号，就不执行扩展。只能用eval当字符串处理。
		printf "%70s\n" | tr ' ' '-'
	done
	exit
fi

for f in $@; do	# 读取参数，是文件目录就备份。
	#~ echo $f
	if [ -e $f ]; then
		#~ fn=`basename $f`
		#~ pref="${HOME}/."
		#~ echo $pref
		#~ echo $f|sed "s|${pref}|+|; s|/|+|g; s|\ |=|g"
		cf=`echo $f|sed "s|${HOME}/.|+|; s|/|+|g; s|\ |=|g"`
		cmd="mv $f $cf; ln -sf $d/$cf $f"
		#~ echo $cmd
		eval $cmd
		eval "\ls --color=always -l $f"	# 变量中带~号，就不执行扩展。只能用eval当字符串处理。
		printf "%70s\n" | tr ' ' '-'
	else
		echo $f 没有找到。
	fi
done
#~ 备份：
#~ mv ~/.config/geany/colorschemes ~/bin/config/+config+geany+colorschemes

#find . -maxdepth 3 -type l -exec rm {} \;

#~ ~/.bashrc
#~ ~/.gitconfig
#~ ~/.local/share/fonts/FiraMono-Regular.ttf
#~ ~/.local/share/fonts/Museo500-Regular.otf
#~ ~/.config/geany/colorschemes/
#~ ~/.local/share/applications/
#~ ~/.local/share/icons/Qetzal/
