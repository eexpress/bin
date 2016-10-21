---
title: 终于找到最好的markdown编辑器
date: 2016-10-20 11:48:42
tags:
- markdown
---
一直使用 vim + multimarkdown + css 作为编写工具组合。唯一就是不方便预览，虽然vim里面设置了f9就是浏览器预览，还是感到节奏不顺。

测试过各种 markdown 编辑器，在线的，node.js的，等等，无一完全满意。
最终无意间想起了geany。geany作为代码编辑器，已经比vim插件配置方便了很多很多，各种函数／跳转／补全自带。随手搜索了下插件，发现了 geany-plugin-markdown。
在侧栏打开预览，格式很顺利的兼容 multimarkdown，只有样式要设置。
在插件目录，按照template.html建立一个自己的html，插入css定义，爽得很。
```
▶ diff eexpss.html template.html 
14d13
< <link href="mkd.css" rel="stylesheet" type="text/css">
```
把各种其他的 markdown 预览软件一把删除了。

