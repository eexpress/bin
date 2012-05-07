#!/bin/bash

if [ -z $1 ]; then s=`xsel -o`; [ -z $s ] && echo "需要参数或者剪贴板内容，以指明ip地址或者域名。" && exit; else s=$1; fi

r=`w3m -dump -no-cookie http://www.ip138.com/ips138.asp?ip=$s|grep '数据：'|sed 's/.*：//'`

echo $r
~/bin/msg "IP地址查询：$s" $r
