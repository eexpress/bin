title: 转换百度空间到hexo的脚本
date: 2014-10-11 15:02:36
tags:
- perl
---
百度空间啥功能都没了。转markdown的hexo去。
选择文字，如图。
![](/img/xsel2hexo.png)
然后执行
```
xsel2hexo.pl
```
会生成hexo的帖子，用gvim打开。几乎不要修改就可以保存。图片需要另外插入，会生成类似 ```![](/img/)``` 的格式，方便填写。
