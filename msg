#!/bin/bash

title="计划任务提醒"
icon="/usr/share/icons/gnome/48x48/actions/system-search.png"
#sound="/home/eexp/bin/resources/sound/kongas.ogg"
#[ -f $sound ] || sound="/usr/share/sounds/gnome/default/alerts/drip.ogg"
sound="/usr/share/sounds/gnome/default/alerts/drip.ogg"
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
export DISPLAY=:0.0 && notify-send -i $icon "$title" "$msg" &
#/usr/share/sounds/ubuntu/stereo
[ -f "$sound" ] && paplay $sound || canberra-gtk-play -i window-slide
# stock icon locate at:
# /usr/share/notify-osd/icons/gnome/
# /usr/share/icons/gnome/
