#!/bin/bash

#插入usb，点开“USB共享网络”，执行此脚本，将tethering变reverse tethering。
ifconfig usb0
[ $? -eq 1 ] && echo "USB0 还没有连接" && exit
sudo ifconfig usb0 10.42.0.1 netmask 255.255.255.0
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -F
sudo iptables -t nat -A POSTROUTING -j MASQUERADE
#▶ route|grep wlan0|grep 255|cut -d '.' -f 1-3 -s
#192.168.8
#sudo route add default gw 192.168.8.1 dev wlan0
sudo ip route add default via 192.168.8.1
#sudo ip route add default dev wlan0 via 192.168.8.1
#----------------------------
adb root
adb shell busybox ifconfig rndis0|grep 'not found'
[ $? -eq 0 ] && echo "rndis0 没有设备";exit
#adb shell netcfg rndis0 dhcp
adb shell busybox ifconfig rndis0 10.42.0.2 netmask 255.255.255.0
adb shell route add default gw 10.42.0.1 dev rndis0
