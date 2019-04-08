title: 改进的loc
date: 2014-11-05 09:35:33
tags:
- locate
---
老版本的是这样
```
loc(){ locate -eLin $(($LINES-4)) -r "^`pwd`.*$1[^\/]*$"; }
```
发现一个新的好用的参数，改进了一个更好的版本。使用的方便程度和 ~/bin/fd 差不多了。多数时间可以替换 fd了。
```
▶ cat ~/bin/loc
#!/bin/bash

r=`echo $*|sed 's/\ /|/g'`
locate -AbeLi $*|grep "^`pwd`"|grep --color=always -iE "$r"
```

