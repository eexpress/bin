---
title: 终于找到最好的markdown编辑器
date: 2016-10-20 11:48:42
tags:
- markdown
---
一直使用 vim + multimarkdown + css + webbrowser  作为编写工具组合。
唯一就是不方便预览，虽然vim里面设置了f9就是浏览器预览，还是感到节奏不顺，浏览器不能设置自动刷新某一页面。

#### 改成　wkhtmltopdf　+ evince 直接预览pdf输出。

把vimrc里面的改了下，比较完美了。evince 会独占并自动刷新显示。
另外，wkhtmltopdf　对于css里面设置的字体，都非常认真的**按次序**显示，还可以 -g 进行灰度输出，很满意。
唯一一个缺点，wkhtmltopdf有一个4年前的bug，不能设置上下的边距，-T -B 无效。

```
	exec "!multimarkdown \'%\'>\'%.html\'; [ $? == 0 ] && wkhtmltopdf \'%.html\' \'%.pdf\'; evince \'%.pdf\' &"
```

#### 独立的带自动同步预览的编辑器

我的目的是要支持**表格**，常规文档代替 doc/odt。
测试过各种 markdown 编辑器，在线的，node.js的，等等，无一满意。
很多软件，不提名字吧，连一行内多个斜体的格式，都识别错误。不知道有[peg](https://en.wikipedia.org/wiki/Parsing_expression_grammar)么？
haroopad 兼容较好，仅仅表格兼容差些，但输出pdf居然内存泄漏，死机。
Editor.md 不错，仅仅表格兼容差些，但是是一个平台，不知道怎么搭建本地的。
最终无意间想起了geany，原生软件多好。geany作为代码编辑器，已经比vim插件配置方便了很多很多，各种函数／跳转／补全自带。随手搜索了下插件，发现了 geany-plugin-markdown。
在侧栏打开预览，格式很顺利的兼容 multimarkdown（表格轻微不兼容 multimarkdown），只有css样式要设置。
在插件目录，按照template.html建立一个自己的html，插入css定义，爽得很。

```
▶ diff eexpss.html template.html 
14d13
< <link href="mkd.css" rel="stylesheet" type="text/css">
```

果断把各种其他的 markdown 预览软件一把删除了。真有点想替代vim了。
唯一缺点就是　geany-plugin-markdown　不能输出html/pdf，看了源码，居然是直接字符串送入WebKit的控件，要是改一个文件输出的patch，估计维护者难通过。


