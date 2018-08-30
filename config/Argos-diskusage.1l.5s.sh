#!/usr/bin/env bash

bar(){ # input: Total, Used
	div=10; Total=${1%G}; Used=${2%G}
	if [ $Total -lt 100 ]; then div=5; fi
	Total=$[$Total/$div]; Used=$[$Used/$div]
	green='\e[1;32m'; end='\e[0m'; red='\e[1;31m'
#        echo -e "$red"
	for (( i=0; i<$Total; i++ )); do
		if [ $i -eq $Used ]; then echo -en "$green"; fi
		echo -n "■"
	done
	echo -e "$end"
}

echo "▶  系统信息"
#loop 3 seconds
#echo "▶  System Info"
echo "---"

#if [ "$ARGOS_MENU_OPEN" == "true" ]; then
echo ":computer:  磁盘使用状况"

/usr/bin/df -h --output=source,fstype,size,used,pcent,target | sed '/tmpfs/d; /boot/d; s./dev/..; s/$/| font=monospace iconName=drive-harddisk/g' \
| awk '{print $0; if($4~/[0-9]+G/) \
{printf("%s\n", "'"`bar $3 $4`"'")}}'
#{printf("%s\n", "-----"$3"----"$4"----->\n")}}'

echo "------------------------"
#echo -ne "最新接入的设备\t\t\e[38;5;6m "	#no support for 256 color?
echo -ne "最新接入的设备\t\t\e[1;2;36m "

OUT=$(dmesg|grep '\<Product:'|tail -n 1|grep -v '\ 1\.'|sed 's/.*://')
case $OUT in
*Mouse)
	DEV=input-mouse;;
*Webcam*)
	DEV=camera-web;;
*)
	DEV=computer;;
esac
OUT=$OUT" \e[0m | iconName=$DEV font='Blogger Sans Medium' size=12"
echo -e $OUT

echo "------------------------"
echo ":computer:  最高占用"

top -bn 1 | grep "^ " | awk '{ printf("%s\t%s\t%s\t%s\n", $1, $9, $10, $12); }' | head -n 4 | sed 's/$/| font=monospace iconName=dialog-warning/g'

echo "------------------------"
echo -n "网络信息\t\t"
ip route | grep -m 1 '0/24' | awk '{print "设备名：",$3, "\t\t地址：", $9}' | sed 's/$/| font=monospace iconName=network-wireless/'

