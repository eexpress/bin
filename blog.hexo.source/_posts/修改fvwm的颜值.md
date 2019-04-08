---
title: 修改fvwm的颜值
date: 2016-09-19 13:21:30
tags:
- fvwm
---
好久没动过fvwm了。配置文件倒是可以直接使用，就是界面颜值忘记如何调整的了。
关于gtk2/3的字体和主题
```
▶ dog ~/.gtkrc-2.0 
gtk-font-name = "Vera Sans YuanTi 11"
gtk-theme-name = "Ambiance"
▶ dog ~/.config/gtk-3.0/settings.ini
[Settings]
gtk-font-name = Vera Sans YuanTi 11
gtk-theme-name = Ambiance
```
关于光标，只能由X11控制，适应于gtk/qt界面，顺便调整下Xterm，万一要用过呢。现在只有root窗口光标不对，哎，忘记了。
```
▶ dog ~/.Xresources 
Xcursor.theme:				Qetzal
Xcursor.size:				64
xterm*faceName:				Courier New:antialias=True:style=Bold
xterm*faceNameDoublesize:	Vera Sans YuanTi Mono:antialias=True
xterm*faceSize:				13
xterm*VT100.geometry:		80x40
xterm*background:			#300A24
```

