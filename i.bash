#! /bin/bash

KEY=$RANDOM

free|grep '[0-9]'|awk '{printf "%s\n%s\n%s\n",$1,$2*1000,($3/$2*100)}'|\
    yad --plug=$KEY --tabnum=1 --image=gnome-dev-memory  --list --no-selection \
        --column=$"名称" --column=$"容量:sz" --column=$"已用:bar" &

df -hT -x tmpfs -x devtmpfs |grep dev| awk '{printf "%s\n%s\n%s\n%s\n%s\n", $7, $2, $3, $5, $6}' |\
    yad --plug=$KEY --tabnum=2 --image=drive-harddisk --list --no-selection \
        --column=$"挂载点" --column=$"类型" \
        --column=$"容量" --column=$"可用" --column=$"已用:bar" &

#~ sensors | while read ln; do
#~ case $ln in
	#~ "") ;;
	#~ Adapter:*) echo $ln|sed 's/Adapter:[ ]*//'	;;
	#~ *:*) 	echo $ln|sed 's/:[ ]*/\n/' ;;
	#~ *) echo "<b>$ln</b>" ;;
#~ esac
#~ done
sensors|grep Core|sed 's/:[ ]*/\n/'|\
yad --plug=$KEY --tabnum=3  --image=info --list --no-selection \
    --column=$"Sensor" --column=$"Value" &

#~ -------------------------------------------------
TXT=$"\\n\\t系统: $(lsb_release -ds) on $(hostname)\\n"
TXT+=$"\\t内核: $(uname -sr)"

yad --notebook --width=500 --height=500 --title=$"系统信息" --text="$TXT" --button="离开" --key=$KEY --tab=$"内存" --tab=$"硬盘"  --tab="温度"
#~ yad --paned --width=700 --height=900 --splitter=250 --title=$"系统信息" --text="$TXT" --button="离开" --key=$KEY --tab=$"内存" --tab=$"硬盘"  --tab="温度"
#~ Paned works in a same manner as a notebook with one restriction - only first and secong plug dialogs will be swallowed to panes.
#~ Paned 只能显示两个tab，而且分隔位置不知道如何设置。多数时间一半为黑色。
