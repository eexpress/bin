#!/bin/bash

title="计划任务提醒"
icon="/usr/share/pixmaps/ubuntu-screensaver.svg"
sound="/home/eexp/bin/resources/sound/kongas.ogg"
case $# in
1)
	msg=$1;;
2)
	title=$1; msg=$2;;
3)
	icon=$1; title=$2; msg=$3;;
4)
	sound=$1; icon=$2; title=$3; msg=$4;;
*)
	title="格式错误"; msg="参数应该介于1－4个。依此为：sound icon title text。";;
esac
msg=`echo $msg|ascii2uni -a J -q`
export DISPLAY=:0.0 && notify-send -i $icon "$title" "$msg"
paplay $sound
