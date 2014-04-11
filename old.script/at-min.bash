#!/bin/bash

t=`echo "$1"|grep '^[0-9]\+$'`
while [ -z "$t" ]
do
echo "输入定时参数。数字，分钟为单位。"
read i
t=`echo "$i"|grep '^[0-9]\+$'`
done
shift
m="$*"
[ -z "$m" ] && echo "输入提示文字，可为空。" && read m
echo $t 分钟后，将提示 “ $m ”。
echo msg """$m"""|at "now + $t minutes"
#echo msg """$2"""|at "now + $1 minutes"

