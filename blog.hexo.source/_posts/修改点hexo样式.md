title: 修改点hexo样式
date: 2014-10-21 13:08:28
tags:
- hexo
- css
---
hexo的样式，不统一，分散。其实只需要调整点点，可是没找到全局覆盖的方法。
之前改过一次的，被冲掉了，又要重新找。
编辑 `./themes/landscape-plus/source/css/_partial/article.styl`
给文章标题，增加点阴影
```
.article-title
  text-shadow: 1px 1px 2px #666;
```
编辑 `./themes/landscape-plus/source/css/_partial/highlight.styl`
代码换个字体，加大点。去掉难看的滚动条。
```
.article-entry
  pre, code
    font-family: 'Courier 10 Pitch',"Courier New",Monospace;
    font-size:  1.2em
$code-block
  overflow: hidden
```
额，发现上传后无效。
修改样式后，需要hexo clean一次，这样全部内容都要重新g一次再d，觉得是一个不人性的地方。

