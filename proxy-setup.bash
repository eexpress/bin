#!/bin/bash

if [[ -f "$1" && "$1" =~ .*\.pac ]]; then
	gsettings set org.gnome.system.proxy autoconfig-url "file://$1"
	gsettings set org.gnome.system.proxy mode 'auto'

	gsettings get org.gnome.system.proxy autoconfig-url
	gsettings get org.gnome.system.proxy mode
	exit
fi

if [[ "$1" =~  ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:[0-9]{3,5}$ ]]; then
	readarray -d : -t strarr <<<"$1"

	gsettings set org.gnome.system.proxy.http host ${strarr[0]}
	gsettings set org.gnome.system.proxy.https host ${strarr[0]}
	gsettings set org.gnome.system.proxy.socks host ${strarr[0]}

	gsettings set org.gnome.system.proxy.http port ${strarr[1]}
	gsettings set org.gnome.system.proxy.https port ${strarr[1]}
	gsettings set org.gnome.system.proxy.socks port ${strarr[1]}

	gsettings set org.gnome.system.proxy mode 'manual'

	gsettings get org.gnome.system.proxy.http host
	gsettings get org.gnome.system.proxy.https host
	gsettings get org.gnome.system.proxy.socks host

	gsettings get org.gnome.system.proxy.http port
	gsettings get org.gnome.system.proxy.https port
	gsettings get org.gnome.system.proxy.socks port

	gsettings get org.gnome.system.proxy mode
	exit
fi

gsettings set org.gnome.system.proxy mode 'none'
gsettings get org.gnome.system.proxy mode

echo "
#~ 输入格式如果是pac文件，设置自动。
#~ 输入格式如果是 IP:PORT 格式。设置手动。
#~ 其他情况，设置禁止。
"
