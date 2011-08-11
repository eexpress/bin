#!/bin/bash

new="/tmp/findnew"
touch $new
read -p "开始监视缓冲。。视频传输完成后，按回车。"
find ~/.opera/cache*/ -iname "opr*.tmp" -newer $new -size +1000k -printf "------\t%p\t► %Ac\t► %kK\t►" -exec file -b {} \; -exec mv {} ~ \;
echo "视频已经复制到家目录。"
