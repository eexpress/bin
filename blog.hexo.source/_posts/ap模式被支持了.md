title: ap模式被支持了
date: 2014-09-09 14:54
tags:
- AP
---
先建立ad-hoc连接，然后编辑配置文件，如 /etc/NetworkManager/system-connections/xxxx，xxxx就是连接的ssid。

里面的mode=yyyy改成ap。

因为没有启动dhcpd，手机需要静态ip，如 10.42.0.5，对应于ifconfig里面的wlan0的ip段。

如果geek点，还是用脚本，带dhcp。https://github.com/eexpress/eexp-bin/blob/master/ap.bash

