title: "adb的无线调试开关"
date: 2015-04-29 20:53:46
tags:
- adb
---
以前无线adb需要安装一个软件。现在发现CM12自带了开关。
![](/img/adbtcpip.png)
打开才有5555端口。lan脚本刷一下就看到。
```
Nmap scan report for Nexus5.lan (192.168.8.200)
Host is up (0.094s latency).
```
然后可以直接连接了。
```
adb connect 192.168.8.200
```
