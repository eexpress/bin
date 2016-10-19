title: libtext-multimarkdown-perl
date: 2014-07-22 09:54
tags:
- markdown
- multimarkdown
- pandoc
---
原来安装这个，直接就使用multimarkdown了。支持extra各种特性。在vim里面使用非常方便。
pandoc可以转换html到markdown，但是不支持表格输出。
```
pandoc -f html -t markdown -o output.md input.html
```
有一个本地**remarkable**的gui前端，支持css导入，但是*识别一行内的多个斜体*，有问题，估计是支持的语法兼容问题，已提交bug。
有趣的是，pandoc转换md到html（支持带css转换），也遇到一样的问题。另外表格有些格式不兼容。
```
▶ pandoc -f markdown -t html -o output.html input.html -c ~/bin/mkd/mkd.css
```
一些浏览器插件，说预览md的，格式更加成问题。

另外安装了一个**haroopad**（体积较大），基本兼容multimarkdown，只有表格需要调整些空白字符。另外字体不使用定义的字体。载入css，不知道怎么刷新或者判断当前到底是用哪种css主题，只能调整字体大小来刷新预览显示。
打印输出pdf，居然内存泄漏，导致死机。
