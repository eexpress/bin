#!/bin/bash

remote=$(avahi-browse -at|grep v4|grep -v `hostname`|awk '{print $4;}'|grep -i "$1")
[ -z $remote ] && echo "没有发现远程机器。" && exit
echo $remote|grep '\ ' >/dev/null
[ $? -eq 0 ] && echo "发现多于一台的远程机器，请指定特征字符串。" && exit

dest=$(echo 'eexp@'$remote'.local')
echo $dest
dir=`pwd`

echo "-----------------------"
ls -1>/tmp/this
ssh $dest ls -1 $dir |diff /tmp/this -|grep '^<'|sed 's/^<\s*//'>/tmp/scp.list
cnt=`cat /tmp/scp.list |wc -l`
[ $cnt -eq 0 ] && echo "本地目录没有发现比远程目录更多的文件。" && exit
cat /tmp/scp.list
echo "-----------------------"
echo "复制当前目录的文件到远程相同目录，确认执行，请按空格键/回车键。其他键取消。"
read -s -n 1 y
if [[ $y == '' ]]; then
	cat /tmp/scp.list |while read i ; do scp $i $dest:$dir; done
fi
