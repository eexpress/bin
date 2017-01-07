---
title: nautilus-actions
date: 2016-12-30 17:12:26
tags:
- nautilus
---
现在的gitg蛮好用了，可以提交，差异比较也好看，比cli直观。
把nautilus-actions又找了出来，加了一个gitg的菜单，顺便还增加了一个gprename的项目。
只选择 *Display item in location context menu*，就是在不选择文件的时候，才出现，直接操作目录。命令的参数使用 %f，这货居然是表示在不选择的时候的当前目录。
目录限制在家目录以下的目录才有效。
![](/img/nautilus-actions.png)

另外一种老办法就是在目录下做一个bash，点击启动。只是这方法只适合于git这种目录应用很少的情况。像gprename那种每个目录都可能用到的情况，就不行了。
```
▶ cat gitg 
#!/bin/bash

gitg
```