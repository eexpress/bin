#!/bin/bash

cd ~/下载
aplay "~/bin/resources/sound/weapon_pkup.wav"
#f=`date '+%Y-%m-%d-%H:%M:%S'`.jpg
f=`date '+%Y-%m-%d-%H:%M:%S'`.png

s="any"		#注释掉，就使用import；否则使用scrot
[ -z $s ] && import -frame $f || scrot -sb $f
convert $f -scale "800x600>" $f
if [ ! -z $1 ]; then /home/eexp/应用/paste-img/pi.pl $f; rm $f;
aplay "~/bin/resources/sound/select.wav"; fi

