#!/bin/bash

v=`pacmd list-sinks|awk '/dB,/{print $5}'`
echo $v
l="off"
if [[ "$v" > "75%" ]]; then l="high";
elif [[ "$v" > "50%" ]]; then l="medium";
elif [[ "$v" > "25%" ]]; then l="low";
fi

pacmd list-sinks|grep 'muted: yes' && l="muted"
echo $l
icon="notification-audio-volume-"$l
notify-send " " -i $icon -h int:value:$v
