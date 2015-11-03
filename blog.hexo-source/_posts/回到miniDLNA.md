title: 回到miniDLNA
date: 2015-03-31 22:43:53
tags:
- DLNA
---
之前用mediatomb，记得miniDLNA识别路径有问题的。
最近发现openwrt里面的miniDLNA还比较流畅，又安装回来，conf里面的路径似乎蛮正常了，而且设置简单，不需要像mediatomb那样增加2行UTF8的设置。
miniDLNA还在使用sysV服务架构。
最简单也可以这样，restart服务一次就可以了。
```
▶ sudo ln -sf '/home/eexp/音乐' /var/lib/minidlna/音乐
```
