#!/bin/bash

# `shadowsocks-libev` (need `sudo dnf copr enable librehat/shadowsocks`) (*ss-local*) (depend on *libsodium* support *chacha20-ietf-poly1305*) 

#**conflicts** with `python3-shadowsocks` (*sslocal*)

#shadowsocks-local-linux64-1.1.5 -c bin/config/shadowsocks-csho.json 
#2019/04/09 00:07:24 Failed generating ciphers:Unsupported encryption method: chacha20-ietf-poly1305

configpath="$HOME/bin/config/proxy.config/"		#要带后缀的/
configfile="*.pac ss-*.json vv-*.json"
v2raycmd="/home/eexpss/bin/app/v2ray-linux-64/v2ray"

killall(){
	sudo pkill -9 -x ss-local
#    sudo pkill -9 -x sslocal
	sudo sslocal -d stop 2>/dev/null
	sudo pkill -9 -x ${v2raycmd##*/}
}

cd $configpath
echo "0 --> none proxy"; files[0]="none";
echo "1 --> all proxy"; files[1]="all";
index=2; for file in $configfile; do files[$index]=$file; echo "$index --> ${files[$index]%.json}"; ((index++)); done
key=99; until [[ $key -lt $index && $key -ge 0 ]]; do read -p  "Please choose config [0-$((index-1))]: " -t 5 -n 1 key; done
# dealy 5 seconds, default choose 0
key=${files[$key]}; echo ""; echo "Choose : $key"

case $key in
	none)
		echo "关闭全局代理"
		gsettings set org.gnome.system.proxy mode 'none'
		;;
	all)
		echo "全部数据走代理"
		gsettings set org.gnome.system.proxy mode 'manual'
		gsettings set org.gnome.system.proxy.http host ''
		gsettings set org.gnome.system.proxy.https host ''
		gsettings set org.gnome.system.proxy.ftp host ''
		gsettings set org.gnome.system.proxy.socks port 1080
		gsettings set org.gnome.system.proxy.socks host '127.0.0.1'
		;;
	*.pac)
		echo "自定义代理 $key"
		fullpath="file://$configpath$key"
		gsettings set org.gnome.system.proxy autoconfig-url "$fullpath"
		gsettings set org.gnome.system.proxy mode 'auto'
		;;
	ss-*.json)
		echo "切换到ss代理 $key"
		killall
		if type ss-local >/dev/null 2>&1; then
			sudo ss-local -c $key --fast-open &
		elif type sslocal >/dev/null 2>&1; then
			sudo sslocal -c $key -d start --fast-open
		else
			echo "没安装命令行的ss软件。"; exit
		fi
		sudo lsof -i :1080
		;;
	vv-*.json)
		echo "切换到v2ray代理 $key"
		killall
		if [ -x $v2raycmd ]; then
			sudo $v2raycmd -config $key &
		else
			echo "没安装命令行的v2ray软件。"; exit
		fi
		;;
esac
