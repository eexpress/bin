---
title: gnome-shell下的Argos
date: 2018-08-30 21:34:19
tags:
- gnome-shell
- Argos
---
用系统支持的各种语言，写gnome-shell扩展。这个扩展还蛮不错的。
写了一个查看常用信息的bash，今天准备增加点字符图形效果，发现bash下awk调用bash内部函数，很麻烦，折腾大半小时，最后还卡在函数输出ESC序列，导致awk不执行上。结果干脆又转成perl。

>bar函数第一行输出ESC颜色，就导致awk完蛋。
```
/usr/bin/df -h --output=source,fstype,size,used,pcent,target | sed '/tmpfs/d; /boot/d; s./dev/..; s/$/| font=monospace iconName=drive-harddisk/g' | awk '{print $0; if($4~/[0-9]+G/) {printf("%s\n", "'"`bar $3 $4`"'")}}'
```

**稍微麻烦的脚本，都直接上perl。** -- 老子记住了。
perl版本效果图：
![](/img/argos.png)
