title: 测试texmaker
date: 2013-02-21 11:02
tags:
- latex
- xelatex
- xeCJK
- texmaker 
---
一直用vim写的。今天测试下texmaker。
安装texlive-xetex texmaker，依赖让系统自动搞定。
菜单->选项->配置Texmaker->快速构建->用户：
1
xelatex -interaction=nonstopmode %.tex|
用户自定义->自定义标签->编辑用户自定义标签：
Menu1: 插入xeCJK设置
Latex内容：
``` latex
\usepackage{xeCJK} %中文字体
\setmainfont{Vera Sans YuanTi} % xeCJK
\setCJKmainfont{Vera Sans YuanTi}
\renewcommand{\baselinestretch}{1.5} %行间距
```
然后就可以开工了。
向导->文档。Shift-F1（插入xeCJK设置）。F1（快速构建）。F7（查看pdf）。
