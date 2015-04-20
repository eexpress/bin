title: 使用reveal.js
date: 2014-10-22 11:54:24
tags:
- reveal.js
- pandoc
- 幻灯
---
克隆下
```
▶ git clone https://github.com/hakimel/reveal.js
```
建立一个markdown文件，用pandoc转成html，就是一个HTML5/CSS3的幻灯演示了。
```
▶ pandoc slides.md -o slides.html -t revealjs -s -V theme=beige -V transition=page
```
reveal.js 支持的主题：
1. default 默认 (深灰色背景，白色文字)
1. beige 米色 (米色背景，深色文字)
1. sky 天空 (天蓝色背景，白色细文字)
1. night 暗夜 (黑色背景，白色粗文字)
1. serif 衬线 (浅色背景，灰色衬线文字)
1. simple 简洁 (白色背景，黑色文字)

还有过渡效果：
1. cube 魔方
1. page 翻页
1. concave 内旋转
1. zoom 放大
1. linear 线性
1. none 无效果
1. 默认
