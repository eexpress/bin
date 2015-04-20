title: rpi播放视频
date: 2012-12-29 20:57
tags:
- raspberry pi 
- rpi
---
![](/img/rpi.jpg)
居然是omxplayer才流畅。白安装了mplayer。
pi@raspberrypi ~ $ sudo mount -o nolock 192.168.1.101:/home/eexp/视频 tmp
pi@raspberrypi ~/tmp/动画/1.国语版本 $ omxplayer -o hdmi  卑鄙的我-2010-Despicable.Me.avi
