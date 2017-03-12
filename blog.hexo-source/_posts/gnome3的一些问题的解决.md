---
title: gnome3的一些问题的解决
date: 2017-03-12 17:31:27
tags:
- gnome3
---

1. 屏幕录像问题
	- gtk-recordmydesktop的停止按钮，在左下角的工具栏，刚来的人真找不到。
	- 内建的全屏幕录像，使用 Alt+Control+Shift+R 启动和停止，右上角只有一个红色录像小图标的提示，webm的文件直接放到视频目录。
1. super键的搜索，中文不出候选栏。
1. 自己的desktop无法拖入到启动侧栏。只能ln到~/.local/share/applications，然后搜索，添加。
1. gnome-screenshot --delay 5 延时菜单截屏，不出保存窗口了。只好附加强制保存文件的参数 -f ~/t.png。
