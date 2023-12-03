#!/bin/bash

#~ 获取发行版名称
distro=`awk -F'=' '/^ID/{print $2}' /etc/os-release`
if [ $distro == "fedora" ]; then
	#~ 获取活动的网卡名
	dev=`ip address | grep -P '(?<!LOOPBACK),UP,' | awk '{print $2}' | sed 's/://g'`
	echo -e "\e[94mActive device:\e[1;32m" $dev"\e[0m"
	#~ Fedora使用systemd-resolved作为默认的DNS解析器。
	sudo resolvectl dns $dev 223.5.5.5 223.6.6.6
	resolvectl | grep 'DNS Servers'
	#~ resolvectl | grep -A 5 $dev
	#~ resolvectl 不支持 --color=always
fi
