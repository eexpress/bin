title: "浏览器打开swf的bug还在"
date: 2015-06-20 20:36:28
tags:
- swf
- broswer
---
包括opera, firefox都打不开本地swf，其实是一个老bug了。
编辑/usr/share/mime/packages/freedesktop.org.xml
```
\<mime-type type="application/vnd.adobe.flash.movie"\>
```
改成
```
\<mime-type type="application/x-shockwave-flash"\>
```
然后更新下数据库
```
update-mime-database /usr/share/mime
```
再重新安装一次flash插件。
```
▶ sudo apt-get install --reinstall pepperflashplugin-nonfree
```

