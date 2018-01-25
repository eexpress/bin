---
title: hexo使用自己的css
date: 2018-01-25 22:26:21
tags:
- css
- hexo
---
```
cd blog.hexo/themes/yilia/source/css
▶ ln ~/bin/mkd/mkd.css .
▶ cp style.styl style.styl.org
▶ echo -e '\n\n@import "mkd.css";'>>style.styl

```
奇怪的是，有些样式没有被覆盖。
