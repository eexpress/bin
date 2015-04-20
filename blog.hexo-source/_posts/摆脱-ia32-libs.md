title: 摆脱 ia32-libs
date: 2013-01-02 22:58
tags:
- ubuntu 
---
    找到2个 no found 的so。
```
● ldd etqw.x86 |grep found
```
查找缺少的库，所在的包。
```
● apt-file search libSDL-1.2.so.0
libsdl1.2debian: /usr/lib/x86_64-linux-gnu/libSDL-1.2.so.0
libsdl1.2debian: /usr/lib/x86_64-linux-gnu/libSDL-1.2.so.0.11.3
● apt-file search libjpeg.so.62
libjpeg62: /usr/lib/x86_64-linux-gnu/libjpeg.so.62
libjpeg62: /usr/lib/x86_64-linux-gnu/libjpeg.so.62.0.0
libjpeg62-dbg: /usr/lib/debug/usr/lib/x86_64-linux-gnu/libjpeg.so.62.0.0
```
    安装包
```
● ai libsdl1.2debian:i386 libjpeg62:i386
```
顺利运行，另外也恢复了aptitude的使用。
