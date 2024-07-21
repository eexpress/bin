#!/bin/bash

# 强制主显示器的设置分辨率和刷新率
resulution_refresh_rate="3840 2160 60"
# port="DP-1"
# port="HDMI-1"
port=`xrandr|awk '/ connected primary/{printf "%s", $1}'`	#主显示器的端口名

#⭕ cvt 3840 2160 60
# 3840x2160 59.98 Hz (CVT 8.29M9) hsync: 134.18 kHz; pclk: 712.75 MHz
#Modeline "3840x2160_60.00"  712.75  3840 4160 4576 5312  2160 2163 2168 2237 -hsync +vsync
ModeLine=`cvt $resulution_refresh_rate|awk '/Modeline/{$1=""; gsub(/"/, ""); print $0}'`	#删除第一列，去掉所有的双引号。
modename=`echo $ModeLine|awk '{printf "%s",$1}'`		#获取第一列，名称不能带引号。

echo "===> xrandr --newmode $ModeLine"
xrandr --newmode $ModeLine	#xorg.conf的ModeLine语法

echo "===> xrandr --addmode $port $modename"
xrandr --addmode $port $modename

echo "===> xrandr --output $port --mode $modename"
xrandr --output $port --mode $modename

