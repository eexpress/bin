---
title: 本地化vala手册
date: 2019-04-02 18:46:02
tags:
- vala
- devhelp
---
一直上valadoc.org看，网速不对头，感觉偶尔被封。

先这样爬一下。
```
▶ curl https://valadoc.org | grep devhelp | cut -c33- | sed 's/">.*$//'
```
得到一个列表，类似这样的。
```
/xcb-randr/xcb-randr.tar.bz2
/xcb-render/xcb-render.tar.bz2
/xcb-res/xcb-res.tar.bz2
/xcb-shape/xcb-shape.tar.bz2
/xcb-shm/xcb-shm.tar.bz2
/xcb-sync/xcb-sync.tar.bz2
/xcb-xfixes/xcb-xfixes.tar.bz2

```
附加上网址。丢一个文件里面去。
```
http://www.valadoc.org/gtk+-2.0/gtk+-2.0.tar.bz2
http://www.valadoc.org/gtk+-3.0/gtk+-3.0.tar.bz2
http://www.valadoc.org/gtk-vnc-2.0/gtk-vnc-2.0.tar.bz2
http://www.valadoc.org/gtkmozembed/gtkmozembed.tar.bz2
http://www.valadoc.org/gtksourceview-2.0/gtksourceview-2.0.tar.bz2
http://www.valadoc.org/gtksourceview-3.0/gtksourceview-3.0.tar.bz2
http://www.valadoc.org/gudev-1.0/gudev-1.0.tar.bz2
```
下载解压。
```
▶ for i in `cat valadoc.list`; do wget $i && tar -xf `basename $i` -C ~/.local/share/devhelp/books/; done
```
在devhelp里面选择只显示vala语言。这下方便多了。devhelp其实蛮好用的。
---
单行版本。
```
▶ curl https://valadoc.org | grep devhelp | cut -c33- | sed 's/">.*$//'
| while read i; do wget "http://www.valadoc.org"$i && 
tar -xf `basename $i` -C ~/.local/share/devhelp/books/; done
```
