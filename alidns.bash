#!/bin/bash

#~ 获取发行版名称
distro=`awk -F'=' '/^ID/{print $2}' /etc/os-release`
if [ $distro == "fedora" ]; then
	#~ 获取活动的网卡名
	#dev=`ip address | grep -P '(?<!LOOPBACK),UP,' | awk '{print $2}' | sed 's/://g'`
	dev=`ip addr | perl -nE '/^\d:\s(.*):.*state UP/ && print $1;'`
	#echo -e "\e[94mActive device:\e[1;32m" $dev"\e[0m"	#蓝色 + 绿色粗体
	#~ Fedora使用systemd-resolved作为默认的DNS解析器。
	sudo resolvectl dns $dev 223.5.5.5 223.6.6.6
	resolvectl
fi
