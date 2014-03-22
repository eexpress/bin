#!/bin/bash

dest=$(echo 'eexp@'$(avahi-browse -at|grep -v `hostname`|grep v4|awk '{print $4;}')'.local')
dir=`pwd`

ls -1>/tmp/this
ssh $dest ls -1 $dir |diff /tmp/this -|grep '^<'|sed 's/^<\s*//'>/tmp/scp.list
cat /tmp/scp.list
echo "-----------------------"
echo "确认执行，请按空格键/回车键。其他键取消。"
read -s -n 1 y
if [[ $y == '' ]]; then
	cat /tmp/scp.list |while read i ; do scp $i $dest:$dir; done
fi
