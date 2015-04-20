title: tar备份下系统
date: 2014-02-04 16:42
tags:
- tar 
---
![](/img/tar.png)
排除差不多一半目录。准备恢复到其他机器。
● time sudo tar cpzf `hostname`_`lsb_release -rs`_`date +%Y-%m-%d.%H-%M`.tgz / --exclude=/proc --exclude=/lost+found --exclude=/mnt --exclude=/sys --exclude=/tmp --exclude=/var --exclude=/home --exclude=/media

