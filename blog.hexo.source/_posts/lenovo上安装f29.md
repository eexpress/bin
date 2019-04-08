---
title: lenovo-R720上安装f29
date: 2019-01-12 14:21:17
tags:
---
感觉多年的xps要死，想在破win10本本上安装一个f29。挤出点空间。
![](/img/daul-part.jpg)

真折腾。一共安装过3次，强制重启过10多次，才摸清状况。
## AHCI
SATA模式必须`AHCI`，fedora的live u盘才能认到NVMe SSD，害我第一次安装到了普通硬盘上，启动慢得要死。
![](/img/daul-bios.jpg)
最终安装到SSD后，**第一次**启动啥都正常。
![](/img/daul-boot.jpg)
不能正常关机，显示`NMI Watchdog detected hard LOCKUP on CPU XX`。

强制关机后，grub倒是正常显示，可win10不能正常。进fedora，wayland模式进去就五秒死机，xorg登录还能熬上一阵子，然后鼠标不动，神奇的发现触摸板却正常，有几次终端都打不开。一看top，天。某**100%**的进程，*root*下ps显示是shutdownxxxxx，*普通用户*下ps是显示firefox，十分奇葩，而且完全**杀不死**。
![](/img/daul-ps.jpg)
以为用户文件损坏，live启动进去，挂载lvm分区，这也是一个技术活，disks/fdisk显示的uuid都不同，最后在by-id下猜uuid挂载进去的，折腾文件，disk order都修复过两次，无效。
最后觉得还是CPU啥的不能兼容。系统只能丢那里了。
## Intel RST Premium
SATA模式必须是`Intel RST Premium`，原始的win10才能正常启动，否则一直这样。蓝屏看个够。
![](/img/daul-win.jpg)
## wifi
网卡是不正常的，运气好搜索到了，rfkill看到2套模块，第一套硬件开关锁住了。要blacklist ideal-laptop模块。
## 收获
下决心，整理了文件。以后装机，只要git clone一次加一个脚本，可以完全复刻绝大多数配置。敏感的ssh/gpg没搞自动化。

