---
title: usbasp和usb2serial系统自动识别了
date: 2016-08-15 22:01:09
tags:
- usb
- udev
---
以前联机调试，usbasp和usb2serial都需要自己写一行udev规则。
```
Bus 003 Device 016: ID 16c0:05dc Van Ooijen Technische Informatica shared ID for use with libusb
Bus 003 Device 015: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port
```
![](/img/usbdev.png)
今天把老板子拿出来试试，发现居然２个设备都认。只ttyUSB0的权限要自己加入dialout组了。这才舒服了。
```
sudo adduser xxxx dialout
```
