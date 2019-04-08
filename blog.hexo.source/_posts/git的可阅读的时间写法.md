title: git的可阅读的时间写法
date: 2014-04-06 12:46
tags:
- git 
---
log等命令支持--since 和 --until这样可阅读的时间参数（其实还可以使用 --before 和 --after）。
``` bash
▶ git log --since="1 week ago" --until="yesterday"
```
对于没有这些参数的命令，使用@{}语法。
```
▶ git diff master@{'2014.04.01'}
▶ git diff master@{'2 days ago'}
▶ git diff master@{'1 years 3 months ago'}
```
参考：http://alexpeattie.com/blog/working-with-dates-in-git/

