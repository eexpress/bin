title: git跟踪特定文件
date: 2014-01-29 17:43
tags:
- git 
---
![](/img/gitlog.png)
不记得啥时候，某文件被删除了。跟踪下文件。老不记得log的用法。
这里的lg是一个alias。
```
lg = log --graph -20 --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %Cgreen(%cr)%Creset %s'
```
然后git show cea26d4，看当时的修改。

