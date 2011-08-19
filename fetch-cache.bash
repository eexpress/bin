#!/bin/bash

new="/tmp/findnew"
touch $new
read -p "开始监视缓冲。。视频传输完成后，按回车。"
#find ~/.opera/cache*/ -iname "opr*.tmp" -newer $new -size +1000k -printf "------\t%p\t► %Ac\t► %kK\t►" -exec file -b {} \; -exec mv {} ~ \;
find ~/.opera/cache*/ -iname "opr*.tmp" -newer $new -size +1000k|while read i; do file $i|egrep 'Audio|MPEG'; [ $? -eq 0 ] && mv $i ~; done
find ~/.mozilla/firefox/ -iregex ".*/[0-9A-F]*" -newer $new -size +1000k|while read i; do file $i|egrep 'Audio|MPEG'; [ $? -eq 0 ] && mv $i ~; done
echo "视频已经复制到家目录。"
