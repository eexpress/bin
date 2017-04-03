---
title: 为脚本关联mimetype增加个人设置
date: 2017-04-03 09:19:36
tags:
- mimetype
- desktop
---
新系统，不想安装以前的包了。只是在家目录手动增加一个脚本的关联设置。
1. 执行脚本放路径下，比如`~/bin`。
1. `~/.local/share/applications`下，增加desktop文件。
1. desktop对应的图标放`~/.icons`下。
1. 增加的mimetype放`~/.config/mimeapps.list`的`[Added Associations]`段。如果设置为缺省打开，在`[Default Applications]`段写。
