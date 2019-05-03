#!/bin/bash

file="$HOME/bin/config/BT_trackers_best.txt"

[ -f $file ] || wget https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt -O $file

cmd="transmission-remote"	# 需要打开 transmission 的 remote control。
line=`$cmd -l|wc -l`
line=$((line-2))
while [ $line -gt 0 ]; do
	echo "--------------$line-------------"
	$cmd -t $line --stop
	sed '/^$/d' $file | while read tracker; do
		echo $cmd -t $line --tracker-add $tracker
		$cmd -t $line --tracker-add $tracker
# 重复添加，只会显示 Error: invalid argument
	done
	$cmd -t $line --start
	line=$((line-1))
done
