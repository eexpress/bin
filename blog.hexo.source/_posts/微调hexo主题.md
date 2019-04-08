title: "微调hexo主题"
date: 2015-04-05 00:08:50
tags:
- hexo
---
所有操作都在themes/landscape/目录下面。
1. 在_config.yml里面去掉太长的tags。就是"- tag"那行。
1. 替换标题图片source/css/images/banner.jpg。
1. 标题使用阴影字。source/css/_partial/article.styl的.article-title段增加"text-shadow: 1px 1px 4px #666"；hover颜色改成红色。
1. 蓝色的链接丑，source/css/_variables.styl里面color-link改灰色。
1. 链接的hove颜色，没找到，之前修改时候没记录下来，懒得改了。header.styl也懒得改了。
1. 页面的折角，和多说的评论也下次再搞。

hexo s一修改，就出错。nnnnd
```
events.js:72
        throw er; // Unhandled 'error' event
              ^
Error: EISDIR, read
```
