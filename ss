#!/bin/bash

# `shadowsocks-libev` (need `sudo dnf copr enable librehat/shadowsocks`) (*ss-local*) (depend on *libsodium* support *chacha20-ietf-poly1305*) 

#**conflicts** with `python3-shadowsocks` (*sslocal*)

#shadowsocks-local-linux64-1.1.5 -c bin/config/shadowsocks-csho.json 
#2019/04/09 00:07:24 Failed generating ciphers:Unsupported encryption method: chacha20-ietf-poly1305

configpath="$HOME/bin/config/"
#configfile="shadowsocks-*"
configfile="ss-*"

# no parameter means "on", else "off".
if [ -z "$1" ]; then
	# on
	cd $configpath
	index=0; for file in $configfile; do files[$index]=$file; echo "$index --> ${files[$index]#*-}"; ((index++)); done
	key=99; until [[ $key -lt $index ]]; do key=0; read -p  "Please choose config [0-$((index-1))]: " -t 5 -n 1 key; done
# dealy 5 seconds, default choose 0
	echo ""; echo "Choose : ${files[$key]}"

	if type ss-local >/dev/null 2>&1; then
		sudo ss-local -c ${files[$key]} --fast-open &
	elif type sslocal >/dev/null 2>&1; then
        	sudo sslocal -c ${files[$key]} -d start --fast-open
	else
		exit
	fi
	gsettings set org.gnome.system.proxy autoconfig-url "file://$HOME/bin/config/.proxy.pac"
	gsettings set org.gnome.system.proxy mode 'auto'
	sudo lsof -i :1080
else
	# off
	if pgrep ss-local >/dev/null 2>&1; then
		sudo pkill -9 -f ss-local
	elif pgrep sslocal >/dev/null 2>&1; then
		sudo sslocal -d stop
	fi
	gsettings set org.gnome.system.proxy mode 'none'
fi
