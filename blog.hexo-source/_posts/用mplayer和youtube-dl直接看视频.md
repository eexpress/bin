---
title: 用mplayer和youtube-dl直接看视频
date: 2016-09-19 23:41:02
tags:
- mplayer
- youtube
---
看了蛮多写法，发现就这个简单。源里面的quvi只支持http代理。
```
youtube-dl --proxy socks5://localhost:1080 -q -o - $url | mplayer -cache 8192 -
```
