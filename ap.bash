#!/bin/bash

sudo ifconfig wlan0 192.168.0.1 netmask 255.255.255.0
sudo -i sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo pkill -9 dhcpd
sudo -i dhcpd wlan0 -pf /var/run/dhcp-server/dhcpd.pid
#sudo -i dhcpd wlan0 -cf /tmp/dhcpd.conf -pf /var/run/dhcp-server/dhcpd.pid
# ubuntu 下面，居然不能使用 -cf 了。否则也使用/tmp/dhcpd.conf，脚本干净多了。
#● dog /etc/dhcp/dhcpd.conf
#default-lease-time 600;
#max-lease-time 7200;
#subnet 192.168.0.0 netmask 255.255.255.0
#{
# range 192.168.0.2 192.168.0.250;
# option domain-name-servers 8.8.8.8;
# option routers 192.168.0.1;
#}

cat > /tmp/hostapd.conf << EOF
interface=wlan0
#bridge=br0
driver=nl80211
ssid=eexp-hostapd
hw_mode=g
channel=11
#dtim_period=1
#rts_threshold=2347
#fragm_threshold=2346
auth_algs=1
wpa=0
wpa_passphrase=12345678
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF
#没开启密码，要开启，wpa=1。
sudo hostapd -d /tmp/hostapd.conf
#为了方便 ctrl-C 断开。hostapd放最后，这样获取IP有点滞后。
