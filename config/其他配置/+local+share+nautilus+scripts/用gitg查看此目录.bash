#!/bin/bash

dir=`echo -n $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS|head -n 1|sed 's/\x0A//g'`
[ -f "$dir" ] && dir=`dirname "$dir"`
echo "$dir/.git" >> ~/tmp
if [ -e "$dir/.git" ]; then gitg "$dir"; else notify-send "非git仓库"; fi
