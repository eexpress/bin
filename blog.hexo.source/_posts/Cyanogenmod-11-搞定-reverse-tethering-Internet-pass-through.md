title: Cyanogenmod 11 搞定 reverse tethering (Internet pass through)
date: 2014-09-24 22:02
tags:
- reverse tethering
- CM11
- Cyanogenmod
---
![](/img/tether.png)
自带的tethering，倒是非常高级。勾选后，系统立刻自动切换到usb0上网。nnnnnd。
可惜啊。https://forums.oneplus.net/threads/internet-pass-through-cm.111107/
adb 过去，netcfg 连 usb0 都找不到，没法写脚本了。

------------------------------------------
终于找到方法。
forum.xda-developers.com/showthread.php?t=2287494
```
▶ cat bin/reverse-tethering.bash
#!/bin/bash

adb root
adb shell busybox ifconfig
adb shell netcfg rndis0 dhcp
adb shell ifconfig rndis0 10.42.0.2 netmask 255.255.255.0
adb shell route add default gw 10.42.0.1 dev rndis0
```
