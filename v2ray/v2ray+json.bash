#!/bin/bash

#~ ⭕ g application/json ~/.config/mimeapps.list
#~ [Default Applications]
#~ application/json=v2ray+json.desktop
#~ [Added Associations]
#~ application/json=geany.desktop;

#~ file=`echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"|head -n 1`
#~ [[ -z $file ]] && file=$1
file=`realpath $1`
type=`mimetype -b "$file"`
if [[ "$type" == "application/json" ]]; then
	notify-send "🌏 $file"
else
	notify-send "❌❌❌  ${file##*/} 不是json文件。"
	exit
fi

path=`dirname "$file"`
cd $path
file=`basename "$file"`
v2raycmd="/home/eexpss/bin/v2ray/v2ray"

ln -sf "$file" last.json
pkill -9 -x "v2ray"
$v2raycmd -config "$file" &
