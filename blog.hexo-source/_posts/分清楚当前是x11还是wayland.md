---
title: 分清楚当前是x11还是wayland
date: 2017-05-12 12:04:37
tags:
- x11
- wayland
---
今天游戏，居然有些卡，奇怪。

1. `设置-详细信息-总览`里面的图形居然是intel卡。
1. `▶ echo $XDG_SESSION_TYPE`居然是wayland。
1. `glxgears`居然只有不到100fps。
1. redshift-gtk的通知图表居然都没有。
1. nvidia-settings居然不能启动。

这就是工作在wayland下。此时看`sudo lsmod|grep nv`是没意义的，只能说明模块加载了。

应该是开启了自动登陆，系统直接进wayland，注销下，登陆时选择Xorg，nv卡才启动。

