title: css在cgi下不加载
date: 2014-08-04 10:58
tags:
- cgi
- css
---
之前正常，今天突然出现的。各种可能性都测试了，无效。

碰巧用enca看了下全部文件，发现这css居然变了编码。。。。没天理。

mkd.css: Simplified Chinese National Standard; GB2312

enconv一次，啥都正常了。

想不出那个环节会改变编码。

gvim不可能，git push/pull可能？
