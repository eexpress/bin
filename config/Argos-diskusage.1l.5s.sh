#!/usr/bin/env bash

echo "▶  系统信息"
#loop 3 seconds
#echo "▶  System Info"
echo "---"

#if [ "$ARGOS_MENU_OPEN" == "true" ]; then
echo ":computer:  磁盘使用状况"

/usr/bin/df -h --output=source,fstype,size,used,pcent,target | sed '/tmpfs/d; /boot/d; s./dev/..; s/$/| font=monospace iconName=drive-harddisk/g'
#| sed 's/^/-- /g'

echo "------------------------"
echo -n "最新接入的设备名\t"

OUT=$(dmesg|grep '\<Product:'|tail -n 1|grep -v '\ 1\.'|sed 's/.*://')
case $OUT in
*Mouse)
	DEV=input-mouse;;
*Webcam*)
	DEV=camera-web;;
*)
	DEV=computer;;
esac
OUT=$OUT"|iconName=$DEV font=monospace"
echo $OUT

echo "------------------------"
echo ":computer:  最高占用"

top -bn 1 | grep "^ " | awk '{ printf("%s\t%s\t%s\t%s\n", $1, $9, $10, $12); }' | head -n 4 | sed 's/$/| font=monospace iconName=dialog-warning/g'

echo "------------------------"
echo -n "网络信息\t\t"
ip route | grep -m 1 '0/24' | awk '{print "设备名：",$3, "\t\t地址：", $9}' | sed 's/$/| font=monospace iconName=network-wireless/'

