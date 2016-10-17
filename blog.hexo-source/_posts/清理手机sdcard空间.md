---
title: 清理手机sdcard空间
date: 2016-10-17 12:49:45
tags:
- android
- adb
---
手机自带的文件管理，删除tencent目录会吊死，就是该死的tecent目录下有一个很长的像随机字符组成的目录名，里面有几千的小文件，不知道tencent偷了多少用户信息。
```
▶ adb shell rm -r /sdcard/tencent/
```
在/sdcard/下需要留下的其实只有，Pictures(某些软件的截屏)，DCIM(相机照片)，Android(某些游戏的obb，data下其实还有一堆废弃的垃圾软件目录要删除)，TWRP，BaiduMap(离线地图vmp和离线导航包bnav)，４个自己建立的中文目录。
du看下，感觉要完蛋，赶紧重启下手机。居然还是16E。
```
16E	/sdcard/
```
赶紧用baobab看下。
![](/img/baobab.png)
