---
title: 本地化vala手册
date: 2019-04-02 18:46:02
tags:
- vala
- devhelp
---
一直上valadoc.org看，网速不对头，感觉偶尔被封。在哪里找到一个列表，类似这样的。
```
http://www.valadoc.org/gtk+-2.0/gtk+-2.0.tar.bz2
http://www.valadoc.org/gtk+-3.0/gtk+-3.0.tar.bz2
http://www.valadoc.org/gtk-vnc-2.0/gtk-vnc-2.0.tar.bz2
http://www.valadoc.org/gtkmozembed/gtkmozembed.tar.bz2
http://www.valadoc.org/gtksourceview-2.0/gtksourceview-2.0.tar.bz2
http://www.valadoc.org/gtksourceview-3.0/gtksourceview-3.0.tar.bz2
http://www.valadoc.org/gudev-1.0/gudev-1.0.tar.bz2
```
下载解压
```
▶ for i in `cat valadoc.list`; do wget $i && tar -xf `basename $i` -C ~/.local/share/devhelp/books/; done
```
在devhelp里面选择只显示vala语言。这下方便多了。devhelp其实蛮好用的。
