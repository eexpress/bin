#!/bin/bash

v=`xbacklight -get`
v=${v%.*}
echo $v
l="off"
if [[ $v -eq 100 ]]; then l="full";
elif [[ $v -ge 75 ]]; then l="high";
elif [[ $v -ge 50 ]]; then l="medium";
elif [[ $v -ge 25 ]]; then l="low";
fi
echo $l
icon="notification-display-brightness-"$l
notify-send " " -i $icon -h int:value:$v -h string:x-canonical-private-synchronous:brightness
