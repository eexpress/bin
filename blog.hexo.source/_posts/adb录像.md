title: adb录像
date: 2015-03-03 09:22:28
tags:
- adb
- screenrecord
---
就一句调用内置的应用。
``` 
▶ adb shell screenrecord /sdcard/example.mp4
``` 
使用Ctrl-C结束。
顺便把截屏的也放这里。
``` 
▶ adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > ~/android-screen-`date +%Y-%m-%d-%H-%M-%S`.png
▶ adb shell screencap -p /sdcard/screencap.png
``` 
