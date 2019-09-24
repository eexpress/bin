#!/bin/bash

# 切换系统全局代理设置

echo "1. 使用自定义PAC。"
echo "2. 全部走代理。"
echo "3. 禁用代理。"

until [[ $key -lt 4 && $key -gt 0 ]]; do
	key=1; read -p  "------请选择数字 1-3。" -t 5 -n 1 key;
done
# 延时5秒。缺省是1。
echo ""

case $key in
	1)
	gsettings set org.gnome.system.proxy autoconfig-url "file://$HOME/bin/config/eexp.proxy.pac"
	gsettings set org.gnome.system.proxy mode 'auto'
	echo "1. 使用自定义PAC。"
	;;
	2)
	gsettings set org.gnome.system.proxy autoconfig-url "file://$HOME/bin/config/all.proxy.pac"
	gsettings set org.gnome.system.proxy mode 'auto'
	echo "2. 全部走代理。"
	;;
	3) 
	gsettings set org.gnome.system.proxy mode 'none'
	echo "3. 禁用代理。"
	;;
esac

pgrep ss-qt 1>/dev/null || ss-qt5 &

