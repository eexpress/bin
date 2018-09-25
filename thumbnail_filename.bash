#!/bin/bash

#文件名嵌入图片
t=${1%.*}
s=20
#▶ identify -list font|g Fira
convert "$1" -scale 600 -gravity North -pointsize $s -font Fira-Mono-Regular \
-stroke black -strokewidth  6	-annotate +0+$s "$t" \
-stroke white -strokewidth  4	-annotate +0+$s "$t" \
-stroke black -strokewidth  2	-annotate +0+$s "$t" \
"$t""_thumb.png"
