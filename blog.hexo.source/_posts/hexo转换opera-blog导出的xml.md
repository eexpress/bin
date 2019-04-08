title: hexo转换opera blog导出的xml
date: 2014-10-13 14:07:29
tags:
- hexo
---
测试过几个转换脚本，都因为破python版本问题，失败。
发现hexo自带。
先把source/_posts目录改名。别冲突了老的文件。
```
▶ npm install hexo-migrator-wordpress --save
▶ hexo migrate wordpress '/home/eexp/blog-25cf6095.xml' 
```
这样就生成了一堆md。而且没任何出错。
