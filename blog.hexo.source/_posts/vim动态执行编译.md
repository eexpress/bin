---
layout: post
title: vim动态执行编译
date: 2019-04-02 00:08:34
tags:
- vim
- compile
---
最近突然编译需求来了。每一个文件的依赖库都不同，以前vim的编译函数都是扯谈了。干脆写了一个通用的方法的函数。
```
"============ <F5> 运行前五行注释中的命令 =========
map <F5> :call RunComment()<CR>
func RunComment()
	let n = 1
	while n < 5
		let l=getline(n)
		if l =~ '//!'
			echo strpart(l, stridx(l, "!"))
			exec strpart(l, stridx(l, "!"))
		endif
		let n = n + 1
	endwhile
endfunc
```
源码里面类似这样的，直接写编译命令。反正只认包含"//!"的行。
```
▶ head -n 5 ~/bin/showit/showsvgpngtxt.vala 
//▶ valac --pkg gtk+-3.0 --pkg librsvg-2.0 showsvgpngtxt.vala
//!valac --pkg gtk+-3.0 --pkg librsvg-2.0 %
//!./%<
using Gtk;
using Cairo;
```