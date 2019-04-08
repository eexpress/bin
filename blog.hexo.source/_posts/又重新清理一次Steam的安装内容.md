---
title: 又重新清理一次Steam的安装内容
date: 2016-09-13 23:35:29
tags:
- steam
---
先把家目录的东西搬移走。
```
mv ~/.steam* ~/temp/
mv ~/.local/share/Steam/ ~/temp/
```
执行steam，重新下载基本文件。会重新建立上面这两个目录。
折腾完，退出steam。把巨大的游戏目录和标识文件搬移回去。
其实可能没啥用。只是TF2老是崩溃，应该是内存溢出。每次Loading界面，内存就一直飙升，大约２分钟，占用到３.９G才进入主菜单。
```
cd ~/temp/Steam/steamapps
mv appmanifest_* common/ workshop/ ~/.local/share/Steam/steamapps/
```

