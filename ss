#!/bin/bash

if [ -z "$1" ]; then
	# on
	sudo sslocal -c ~/bin/config/shadowsocks.json -d start
	gsettings set org.gnome.system.proxy autoconfig-url "file://$HOME/bin/config/.proxy.pac"
	gsettings set org.gnome.system.proxy mode 'auto'
	sudo lsof -i :1080
else
	# off
	sudo sslocal -d stop
	gsettings set org.gnome.system.proxy mode 'none'
fi
