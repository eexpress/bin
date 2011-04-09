#!/bin/bash

r=`echo -n "ip="$1"&action=2"|w3m -dump -no-cookie http://www.ip138.com/ips8.asp -post -|grep '数据：'|sed 's/.*：//'`
echo $r
msg "IP地址查询：$1" $r
