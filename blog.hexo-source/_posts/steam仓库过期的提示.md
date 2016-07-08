---
title: steam仓库过期的提示
date: 2016-05-31 22:38:58
tags:
- steam
---

老遇到这提示，虽然的确仓库版本不符合16.04，也觉得这提示傻。
> Your steam package is out of date. Please get an updated version from your package provider or directly from http://repo.steampowered.com/steam for supported distributions.

其实是一个自带库很旧，系统的更加高版本，可以这样解决。
```
▶ cd ~/.local/share/Steam/ubuntu12_32/steam-runtime/amd64/lib/x86_64-linux-gnu
▶ mv libpcre.so.3* ~
```
