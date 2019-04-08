---
title: 用retext作为markdown编辑器
date: 2016-11-08 15:41:15
tags:
- markdown
---
源里面有，基于qt5，导出odf/html/pdf都可以。单行多个斜体，要注意使用空格分开_和其他字符。能自动识别md内部带的html和指定的css，包括css里面指定的字体都正常渲染，这点非常满意。

其他各种编辑，转换软件都可以休息了。包括vim的设置都可以去掉了。

```
▶ ap libtext-multimarkdown-perl geany* pandoc wkhtmltopdf 
```
