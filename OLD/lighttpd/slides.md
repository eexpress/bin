% JS 幻灯演示
% Eexprss
% 2014-10-22

# 效果演示

## 列表和链接

- [ Git Repo ](http://localhost:1111/)
- [ Auto Flow Chat ](http://localhost:1111/upload.html)
- [ 博客 ](http://eexpress.github.io)

![vim svg](/usr/share/pixmaps/vim.svg)

## 表格

项目名称|URL|项目名称|URL
--|---|--|---
git的公用测试仓库iccard|[Git Web](http://127.0.0.1:1234)|自动流程图生成flow.pl|[Flow Chat](upload.html)
矢量幻灯演示|[ENN Sozi](enn新奥sozi.svg)|开放代理端口|192.168.100.7:8087
本人的博客|[Blog](http://eexpress.github.io)|ssh代理端口|7070


# 制作步骤


## 安装 reveal.js
```
▶ git clone https://github.com/hakimel/reveal.js
```

## 编写 markdown 文件


## 编译成html
```
▶ pandoc slides.md -o slides.html -t revealjs -s -V theme=default
▶ pkill -9 lighttpd; lighttpd -f lighttpd.html.cgi.conf
```

