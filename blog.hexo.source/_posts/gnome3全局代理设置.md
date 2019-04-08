---
title: gnome3全局代理设置
date: 2016-09-19 13:17:00
tags:
- proxy
---
选项列表
```
▶ gsettings list-recursively org.gnome.system.proxy
org.gnome.system.proxy use-same-proxy false
org.gnome.system.proxy mode 'auto'
org.gnome.system.proxy autoconfig-url '/home/eexp/bin/config/proxy.pac'
org.gnome.system.proxy ignore-hosts ['localhost', '127.0.0.0/8', '::1']
org.gnome.system.proxy.ftp host ''
org.gnome.system.proxy.ftp port 0
org.gnome.system.proxy.socks host '127.0.0.1'
org.gnome.system.proxy.socks port 1080
org.gnome.system.proxy.http host '127.0.0.1'
org.gnome.system.proxy.http port 1080
org.gnome.system.proxy.http use-authentication false
org.gnome.system.proxy.http authentication-password ''
org.gnome.system.proxy.http authentication-user ''
org.gnome.system.proxy.http enabled false
org.gnome.system.proxy.https host ''
org.gnome.system.proxy.https port 0
```
修改某项目
```
▶ gsettings set org.gnome.system.proxy autoconfig-url '/home/eexp/bin/config/proxy.pac'
```
