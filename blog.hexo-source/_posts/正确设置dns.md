title: "正确设置dns"
date: 2015-04-29 22:02:53
tags:
- openwrt
- dns
- dnsmasq
- VPS
---
想要dns正确，去VPS上安装下dnsmasq，设置下端口就成。
```
▶ dog /etc/dnsmasq.conf 
port=5353
```
路由器上别指望界面上可以修改dns的端口。没设置dog的alias。
```
# grep -v -E "(^$|^#|^!)" /etc/dnsmasq.conf
server=45.xxx.xxx.xxx#5353
```
先这样用用再说。

