#!/bin/bash

convert -fill dodgerblue -background none -font /home/exp/安装/备份/字体/中文字体/经典繁颜体.ttf -pointsize 30 label:"$*" -bordercolor black -border 16x16 \( +clone -blur 0x25 -level 0%,50% \) -compose screen -composite ~/下载/f-荧光字.png
paste-img.pl ~/下载/f-荧光字.png
#rm ~/下载/f-荧光字.png

