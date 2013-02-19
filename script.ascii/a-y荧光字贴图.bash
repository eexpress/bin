#!/bin/bash

convert -fill dodgerblue -background none -font /home/eexp/.fonts/园体/VeraSansYuanTi-Regular.ttf -pointsize 30 label:"$*" -bordercolor black -border 16x16 \( +clone -blur 0x25 -level 0%,50% \) -compose screen -composite ~/下载/f-荧光字.png
pasteimg.pl ~/下载/f-荧光字.png
#rm ~/下载/f-荧光字.png

