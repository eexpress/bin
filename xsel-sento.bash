#!/bin/bash

f=`xsel -o|tr '\n' ' '`
cmd=$*" "$f
echo $cmd
echo "-----------------------"
echo "确认执行，请按空格键/回车键。其他键取消。"
read -s -n 1 y
if [[ $y == '' ]]; then
	eval $cmd
fi

