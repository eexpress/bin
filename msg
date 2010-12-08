#!/bin/bash

t="计划任务提醒"
res_path="$HOME/bin/resources/"
icon="spot.jpg"
sound="skill_up.wav"
case $# in
1)
	w=$1;;
2)
	t=$1; w=$2;;
3)
	icon=$1; t=$2; w=$3;;
4)
	sound=$1; icon=$2; t=$3; w=$4;;
*)
	t="格式错误"; w="参数应该介于1－4个。依此为：sound icon title text。";;
esac
w=`echo $w|ascii2uni -a J -q`
export DISPLAY=:0.0 && notify-send -i "$res_path/icon/$icon"  "$t" "$w"
play "$res_path/sound/$sound"  2>/dev/null
