#!/bin/bash

cd /home/exp/下载
aplay '/home/exp/媒体/事件声音-et/weapon_pkup.wav' 
#f=`date '+%Y-%m-%d-%H:%M:%S'`.jpg
f=`date '+%Y-%m-%d-%H:%M:%S'`.png

s="any"		#注释掉，就使用import；否则使用scrot
[ -z $s ] && import -frame $f || scrot -sb $f
convert $f -scale "800x600>" $f
if [ ! -z $1 ]; then ~/bin/paste-img.pl $f; rm $f;
aplay '/home/exp/媒体/事件声音-et/select.wav'; fi

