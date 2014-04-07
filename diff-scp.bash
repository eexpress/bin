#!/bin/bash

#参数1，直接指定远程目录，或者指定远程机器名的关键词（使用相同路径）
if [ -d $1 ]; then
	dest=$1
else
	remote=$(avahi-browse -at|grep v4|grep -v `hostname`|awk '{print $4;}'|grep -i "$1")
	[ -z $remote ] && echo "没有发现远程机器。" && exit
	echo $remote|grep '\ ' >/dev/null
	[ $? -eq 0 ] && echo "发现多于一台的远程机器，请指定特征字符串。" && exit

	dest=$(echo 'eexp@'$remote'.local')
	echo $dest
fi

echo "-----------------------"
dir=`pwd`
ls -1>/tmp/this
ssh $dest ls -1 $dir |diff /tmp/this -|grep '^<'|sed 's/^<\s*//'>/tmp/scp.list
cnt=`cat /tmp/scp.list |wc -l`
[ $cnt -eq 0 ] && echo "本地目录没有发现比远程目录更多的文件。" && exit
cat /tmp/scp.list
echo "-----------------------"
echo "复制当前目录新增的文件到远程相同目录，确认执行，请按空格键/回车键。其他键取消。"
read -s -n 1 y
if [[ $y == '' ]]; then
	cat /tmp/scp.list |while read i ; do scp $i $dest:$dir; done
fi
