title: markdown转pdf的指定编码设置
date: 2014-04-29 00:03
tags:
- charset
- pdf
- markdown 
---
如果有中文，需要先指定编码，再转换。
``` bash
▶ sed -i '1i<meta http-equiv="content-type" content="text/html; charset=UTF-8">' *.md
▶ markdown README.md >t.html
```
