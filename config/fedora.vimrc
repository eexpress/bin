colo evening 		" 配色主题	desert
set guifont=Input\ Mono\ Italic\ 14
set guifont=Fira\ Mono\ 14
set number 			" 显示行号
set mouse=a
set ignorecase		" 搜索忽略大小写
set incsearch		" 输入字符串就显示匹配点

" 关闭窗口/保存文件
map <leader>q	<Esc>:q!<CR>
map <C-u>	:update<CR>
imap <C-u>	<Esc>:update<CR>a
" 输入时自动补全括号
imap ( ()<ESC>i
imap { {}<ESC>i
imap [ []<ESC>i
" 选择文字，用括号包起
vnoremap (( <esc>`>a)<esc>`<i(<esc>i
vnoremap {{ <esc>`>a}<esc>`<i{<esc>i
" 全局替换当前单词
map <expr> <C-w> Replace_Current_Word()
func Replace_Current_Word()
	let w = expand("<cword>")
	return "\<ESC>:%s/\\<".w."\\>/".w."/g\<Left>\<Left>"
endfun
" 智能tab，补全或输入TAB
inoremap <expr> <Tab> MyTab()
fun MyTab()
	let str=strpart(getline("."), 0, col(".")-1)
	if str!="" && str=~'\m\w$'
		return "\<C-N>"
	endif
	return "\t"
endfun
"============= Mimetype ============
"新脚本自动加类型
au BufNewFile *.bash,*.sh	0put='#!/bin/bash'|setf bash|normal Go
au BufNewFile *.perl,*.pl	0put='#!/usr/bin/perl'|setf perl|normal Go
