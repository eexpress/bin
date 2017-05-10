---
title: rsync要点
date: 2015-05-04 14:24:18
tags:
- rsync
---
```
▶ rsync --exclude .git ~/bin/ /media/eexp/数据/bin
▶ rsync ~/音乐/ /media/eexp/媒体/音乐
▶ rsync --exclude QuakeWars --exclude .git --exclude .deploy_git ~/文档/ /media/eexp/数据/文档
▶ rsync '/home/eexp/模板' /media/eexp/数据/
```
-----------------------------------------------
> 源目录跟着/，表示是目录下面的所有文件内容。所以 DEST 需要指明工作目录。
```
▶ rsync bot/ /media/eexp/32G/bot
▶ rsync bot/ /media/eexp/32G/bot/
▶ rsync /home/eexp/bin/bot/ '/media/eexp/32G/bot' 
▶ rsync ~/bin/bot/ '/media/eexp/32G/bot' 
▶ rsync /home/eexp/bin/bot/ /media/eexp/32G/bot/
```
> 源目录不跟着/，表示是目录。所以 DEST 应该指向上层目录。
```
▶ rsync '/home/eexp/bin/bot' '/media/eexp/32G' 
▶ rsync bot /media/eexp/32G/
```
> 错误的用法！！！！
```
▶ rsync bot/ /media/eexp/32G/
```
> 文件都传到根目录了。DEST 没有建立bot目录。
```
▶ rsync '/home/eexp/bin/bot' '/media/eexp/32G/bot'
```
> 传到bot/bot了。

-----------------------------------------------

||rsync 参数说明|
|:--:|--|
*-a*|preserve permissions, timestamps, symlinks, etc. archive 归档模式，表示以递归方式传输文件，并保持所有文件属性，等于-rlptgoD
*-H*|preserve hard links
*-X*|preserve extended attributes
-A|preserve ACLs (implies -p preserve permissions) 
-v|be verbose
-h|human-readable
-u|等同于 –update，在目标文件比源文件新的情况下不更新
-v|显示同步的文件
--progress|显示文件同步时的百分比进度、传输速率
-z|compress the transferred data<br>注：局域网内不需要压缩
-c|check checksums
--partial|keep partially transferred files
-P|same as --partial --progress<br>注：为了续传
-x|don't cross filesystem boundaries
*--delete*|删除目标目录中多于源目录的文件
