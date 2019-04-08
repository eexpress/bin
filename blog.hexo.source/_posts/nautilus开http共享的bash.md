---
title: nautilus开http共享的bash
date: 2016-11-09 13:40:16
tags:
- nautilus
- share
---
发现一个好用的开http的软件，适合指定单个文件或者目录共享。
写了一个脚本，可以放到 _~/.local/share/nautilus/scripts/_ 下面，右键点击文件，选择脚本菜单里面的此脚本，就是开启本机8080端口，走http共享。
脚本带了产生二维码的功能，关闭二维码显示将结束http服务。
![](/img/share-http.png)
```
▶ cat ~/.local/share/nautilus/scripts/share-http.bash 
#!/bin/bash

port=8080
pkill woof
file=`echo -n $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS|sed 's/\x0A//g'`
#echo "->$file<-" >> ~/tmp
woof -c 4 -p $port "$file" &
url=`ifconfig|awk '/inet /&&!/127./{print $2}'|sed 's/.*://'`
qrencode -s 5 -o /tmp/url.png "http://$url:$port"
eog /tmp/url.png && pkill woof
```
需要安装woof和qrencode这2个软件。
这个$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS参数，后面附加了一个“0x0A”，害了我半天。
