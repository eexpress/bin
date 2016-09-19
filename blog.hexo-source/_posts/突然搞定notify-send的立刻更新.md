---
title: 突然搞定notify-send的立刻更新
date: 2016-09-19 16:58:42
tags:
- notify-send
---
其实就是直接加一个字符串。明显内部黑幕。之前折腾--urgency和返回pid的方法，都是害人的。这下一次搞定了Fn多数热键的图形提示功能。
```
notify-send " " -i $icon -h int:value:$v -h string:x-canonical-private-synchronous:brightness
notify-send " " -i $icon -h int:value:$v -h string:x-canonical-private-synchronous:volume
```
图标都在这里。
```
▶ ls /usr/share/notify-osd/icons/Humanity/scalable/status/notification-*
```

