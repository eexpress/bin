#!/bin/bash

t="计划任务提醒"
base_pic_path="$HOME/bin/resources/icon/"
icon=$base_pic_path"spot.jpg"
case $# in
1)
	w=$*;;
2)
	t=$1; w=$2;;
3)
	[ -f "$1" ] && icon=$1 || icon="${base_pic_path}/$1"
	t=$2; w=$3;;
*)
	t="格式错误"; w="参数应该介于1－3个。";;
esac
w=`echo $w|ascii2uni -a J`
export DISPLAY=:0.0 && notify-send -i $icon  $t $w
play '/home/exp/bin/resources/sound/skill_up.wav'  2>/dev/null

