#!/bin/bash

ex()
{
	echo "===> $f"
	e=${f##*.}
	if [ $e == 'rar' ]; then e='unrar'; fi
	p=`$e l $f|grep Comment|sed 's/^Comment:\s*//'`
	if [ -z $p ]; then p='gahdmm.blogspot.com'; fi
	echo -e "\e[1;37;41m$e x -p$p -x"*.url" \"$f\"\e[0m"
	$e x -p$p "$f"
	echo "\n===$e return========$?===========\n"
	zenity --question --title=确认删除 --text="是否删除文件 $f"
	[ $? -eq 0 ] && echo "删除。。。" && rm "$f"
	rm *.url
}

if [ -f "$1" ]; then
	f=$1; ex;
else
	ls -1 *.rar *.7z|while read f; do ex; done
fi
