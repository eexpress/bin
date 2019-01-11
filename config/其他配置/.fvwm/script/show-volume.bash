#!/bin/bash

v=`pacmd list-sinks|awk '/dB,/{print $5}'`
v=${v%\%}
echo $v
l="off"
if [[ $v -ge 75 ]]; then l="high";
elif [[ $v -ge 50 ]]; then l="medium";
elif [[ $v -ge 25 ]]; then l="low";
fi

pacmd list-sinks|grep 'muted: yes' && l="muted"
echo $l
icon="notification-audio-volume-"$l
notify-send " " -i $icon -h int:value:$v -h string:x-canonical-private-synchronous:volume
