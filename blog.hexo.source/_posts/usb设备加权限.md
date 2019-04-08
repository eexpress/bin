title: usb设备加权限
date: 2013-03-04 22:00
tags:
- usbasp
- udev 
---
```
● cat /etc/udev/rules.d/99-usbasp.rules 
SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05dc", GROUP="users", MODE="0666"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="067b", ATTRS{idProduct}=="2303", GROUP="users", MODE="0666"
```
