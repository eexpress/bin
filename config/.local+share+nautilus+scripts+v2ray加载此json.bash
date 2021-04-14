#!/bin/bash

file=`echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"|head -n 1`
type=`mimetype -b "$file"`
if [[ "$type" == "application/json" ]]; then
	notify-send "🌏 $file"
else
	notify-send "❌❌❌  ${file##*/} 不是json文件。"
	exit
fi

path=`dirname "$file"`
last="$path/last.json"
v2raycmd="/home/eexpss/app/v2ray-linux-64-v2fly-v4.36.2/v2ray"

ln -sf "$file" "$last"
pkill -9 -x "v2ray"
$v2raycmd -config "$last" &
