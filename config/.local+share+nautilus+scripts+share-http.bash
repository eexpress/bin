#!/bin/bash

fpng="/tmp/url.png"
port=8080
pkill woof
file=`echo -n $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS|sed 's/\x0A//g'`
msg="扫描下载 "${file##*/}"。\n关闭图片将中止传输。"
echo $msg
#echo "->$file<-" >> ~/tmp
woof -c 4 -p $port "$file" &
url=`ifconfig|awk '/inet /&&!/127./{print $2}'|sed 's/.*://'`
qrencode -s 5 -o $fpng "http://$url:$port"
#字体名带空格的 identify -list font|grep UKai
convert $fpng -background Orange -font 经典综艺体简 -pointsize 16 label:"$msg" -gravity Center -append $fpng.1
eog $fpng.1 && pkill woof

