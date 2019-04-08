---
title: nautilus常显隐藏文件的老bug
date: 2016-06-07 09:02:00
tags:
- nautilus
- show-hidden
---
不知道什么时候，调用file-chooser的时候，就可能打开隐藏文件的显示，然后nautilus就只认file-chooser的这个设置。手动关闭。
```
dconf write /org/gtk/settings/file-chooser/show-hidden false
```
