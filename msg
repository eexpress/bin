#!/bin/bash

title="计划任务提醒"
# Stock Icon:	/usr/share/icons/
icon=alarm-symbolic
# Event Sound:	/usr/share/sounds/*/stereo
sound=complete
case $# in
1)
	msg=$1;;
2)
	title=$1; msg=$2;;
*)
	title="格式错误"; msg="参数：[标题title] 提示文字。";;
esac
export DISPLAY=:0.0 && notify-send -i $icon "$title" "$msg" &
canberra-gtk-play -l 3 -i complete
type 说 && 说 时间到了哦。
