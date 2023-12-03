#!/bin/bash

dev=`ip address | grep -P '(?<!LOOPBACK),UP,' | awk '{print $2}' | sed 's/://g'`
echo -e "\e[1;32mActive device:\e[0m" $dev
sudo resolvectl dns $dev 223.5.5.5 223.6.6.6
resolvectl | grep 'DNS Servers'
#~ resolvectl | grep -A 5 $dev
#~ resolvectl 不支持 --color=always
