#!/bin/bash

cd ~/下载
#play "~/bin/resources/sound/kongas.ogg"
#f=`date '+%Y-%m-%d-%H:%M:%S'`.jpg
f=`date '+%Y-%m-%d-%H:%M:%S'`.png

#s="any"		#注释掉，就使用import；否则使用scrot
[ -z $s ] && import -frame $f || scrot -sb $f
convert $f -scale "800x600>" $f
if [ ! -z $f ]; then ~/bin/paste-img/pasteimg.pl $f; rm $f;
play "~/bin/resources/sound/kongas.ogg"; fi

