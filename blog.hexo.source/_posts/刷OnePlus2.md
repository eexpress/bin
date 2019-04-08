---
title: 刷OnePlus2
date: 2016-11-19 14:34:40
tags:
- twrp
- fastboot
---
udev增加一行。
```
SUBSYSTEM=="usb", ATTR{idVendor}=="05c6", ATTR{idProduct}=="9039", MODE="0666"
```
一台 OnePlus2，原有twrp，刷包一直失败，拿过来直接高级清除，保留sdcard。结果发现这机器sdcard不是独立的，一起都清除没了。在twrp里面进bootloader，就一个Fastboot Mode字样的图片。音量上+电源键也是这样的界面。
只好下载一个twrp，刷进去。（fastboot命令居然能直接补全img）
```
▶ sudo fastboot flash recovery cm-14.1-20161119-NIGHTLY-oneplus2-recovery.img 
target reported max download size of 536870912 bytes
sending 'recovery' (21240 KB)...
OKAY [  0.569s]
writing 'recovery'...
OKAY [  0.190s]
finished. total time: 0.759s
▶ sudo fastboot devices 
61efbe04	fastboot
▶ sudo fastboot oem unlock
...
OKAY [  0.009s]
finished. total time: 0.009s
▶ sudo fastboot boot cm-14.1-20161119-NIGHTLY-oneplus2-recovery.img 
downloading 'boot.img'...
OKAY [  0.564s]
booting...
FAILED (remote: dtb not found)
finished. total time: 0.808s

```
此时用lsusb+diff看，居然发现这个。vid:pid都变了？
```
< Bus 003 Device 031: ID 18d1:d00d Google Inc. 
```

音量下+电源键，或者fastboot reboot，都只能进一个android和一加图标的界面。
```
▶ adb devices 
List of devices attached 
????????????	no permissions
```
