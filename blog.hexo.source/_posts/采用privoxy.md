title: "采用privoxy"
date: 2015-04-26 14:25:38
tags:
- privoxy
- openwrt
---
安装 privoxy 算了。写法简单。
```
▶ cat privoxy.wall.action 
{+forward-override{forward-socks5 localhost:7070}}
.google.com.hk
.facebook.com
.google.com
.....
▶ scp privoxy.wall.action root@192.168.8.1:/etc/privoxy/
```
在路由器上，修改主配置文件/etc/privoxy/config，修改如下几行。启用服务并运行。
```
#logfile privoxy
#actionsfile match-all.action # Actions that are applied to all sites and maybe overruled later on.
#actionsfile default.action   # Main actions file
#actionsfile user.action      # User customizations
actionsfile privoxy.wall.action
listen-address  0.0.0.0:8118

accept-intercepted-requests 1

permit-access  192.168.8.0/24
```
>> nnnnd 又不出端口

折腾几下才发现，一连接，privoxy进程就飞快的崩溃。

后期再搞吧。还准备测试透明的。
```
iptables -t nat -I PREROUTING -i br-+ -p tcp -m multiport --dports 80 -j REDIRECT --to-ports 8118
iptables -t nat -A OUTPUT -p tcp --dport 80 -j REDIRECT --to-ports 8118
iptables -t nat -A OUTPUT -p tcp --dport 80 -m owner --uid-owner privoxy -j ACCEPT
```
