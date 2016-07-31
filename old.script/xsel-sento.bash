#!/bin/bash

f=`xsel -o|tr '\n' ' '|sed 's/\ +/ /g'`
#参数中可使用+号替换xsel结果
echo "$*"|grep '\+'
if [ $? == 0 ]; then
	cmd=`echo $*|sed -e "s'\+'$f'"`
else
	cmd=$*" "$f
fi
echo $cmd
echo "-----------------------"
echo "确认执行，请按空格键/回车键。其他键取消。"
read -s -n 1 y
if [[ $y == '' ]]; then
	eval $cmd
fi

