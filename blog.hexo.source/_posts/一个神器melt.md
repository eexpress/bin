---
title: 一个神器melt
date: 2016-07-29 10:28:48
tags:
- melt
- video
---
自带播放器，指定帧数组合不同的视频/图片，统一编码。
```
▶ melt a.wmv in=100 out=200 b.jpg in=0 out=15 c.avi in=13400 out=13500 d.mp4 in=3000 out=3100 -consumer avformat:OUT.avi acodec=libmp3lame vcodec=libx264
```
也可以保存成记录，下次直接播放。
```
-serialise file.melt
```
只是manpage晦涩难懂。需要到处找例子理解。
在单方面比ffmpeg强大无数，完全没有各种编码的bug。专业级对业余级吧。

