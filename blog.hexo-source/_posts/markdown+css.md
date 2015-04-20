title: markdown+css
date: 2014-07-08 21:27
tags:
- css
- mkd
- markdown 
---
将下面代码加入新建mkd文件的模板。
``` html 	
<head>
<title>MarkDown File</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link href="bin/mkd.css" rel="stylesheet" type="text/css">
</head>
``` 
将下面代码加入.vimrc。
``` bash
map <F9> :call CompileRun()<CR>
func CompileRun()
    if &filetype == 'markdown'
    exec "!markdown \'%\'>\'%.html\'; [ $? == 0 ] && nohup xdg-open \'%.html\' &"
    endif
endfunc
```
然后按F9。
 
效果如下。
![](/img/mk2.jpg)

