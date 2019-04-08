title: nm-applet 休眠掉了
date: 2007-03-08 06:03:43
tags:
---

合上laptop，电源管理里面设置了31分钟后休眠。nm-applet 就休眠掉了。iwlist都可以看到连接。此时重启nm-applet可没用。应该属于要修正的地方，客户都打开laptop盖子，重新登录了，休眠退出了，这NetworkManager（/etc/dbus-1/event.d/25NetworkManager）就不会智能点？

重启NetworkManager。
sudo killall NetworkManager 
sudo NetworkManager --no-daemon
极端的，这样。
sudo /etc/init.d/dbus restart

还有一点，我经常amule或者bt整晚，怎么没见停止呢？