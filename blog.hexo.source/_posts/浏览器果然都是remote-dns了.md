title: 浏览器果然都是remote_dns了
date: 2015-01-05 16:32:46
tags:
- remote_dns
---
卸载了远程的bind9，差点安装dnsmasq，想想正好测试下传说。
network-manager 啥都不设置，全自动获取。/etc/resolv.conf 里面爱写啥写啥。
保留全局的proxy.pac。重连网络，重开opera，就youtube打不开，其他正常，dig没输出了。

