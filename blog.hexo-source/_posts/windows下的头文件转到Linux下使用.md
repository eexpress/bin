title: windows下的头文件转到Linux下使用
date: 2014-04-24 14:38
tags:
- sed
- find
- head 
---
bs傻逼的win路径。
```
▶ find driver/ -iname "*.h" -exec sed '/include/s/\\/\//g' -i {} \;
目录下所有文件名都改小写
▶ find . -type d | while read i; do cd $i; echo -n "-> "; pwd; rename 'y/A-Z/a-z/' *; echo -n "<- "; cd -; done
头文件的路径都改小写
▶ find . -iname "*.h" -exec sed '/include/s/[A-Z]/\l&/g' -i {} \;
win格式的include路径，去掉前缀路径。
▶ sed '/include/s/".*\\/"/g' -i *
```
