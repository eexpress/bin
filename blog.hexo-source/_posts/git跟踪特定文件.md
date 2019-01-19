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
`git lg xxxx`，然后`git show cea26d4 xxxx`，看当时的修改。
也可以 `git co cea26d4 xxxx`，取出这个版本，测试。然后再`git co -- xxxx`来恢复。**危险的命令**。用暂存区覆盖工作区。相当于取消自上次执行git add 以来（如果执行过）的本地修改。
>（使用 "git checkout -- <文件>..." 丢弃工作区的改动）

>（使用 "git reset HEAD <文件>..." 以取消暂存）

![](/img/git-stage.png)

[Git 工作区、暂存区和版本库](http://www.worldhello.net/2010/11/30/2166.html)