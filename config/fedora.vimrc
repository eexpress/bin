" 开启语法高亮
"syntax on 
colo desert
hi PmenuSel ctermfg=7 ctermbg=4 guibg=darkgreen guifg=white
set number
set autochdir
set cindent
set mouse=a
set ignorecase		" 搜索忽略大小写
set smartcase
set display+=lastline
" 设置文字编码自动识别
set encoding=utf-8
set fencs=utf-8,gb18030,ucs-bom,utf-16,big5
set fenc=utf-8
set guifont=Courier\ 10\ Pitch\ 14,Nimbus\ Mono\ L\ 14
" 设置高亮搜索
set hlsearch
set incsearch		" 输入字符串就显示匹配点
set tabstop=4
set shiftwidth=4
"状态栏
set laststatus=2
set statusline=
set statusline+=%-20f
set statusline+=%10.{&encoding}
set statusline+=\ \ \ \ (%3.l,%3.c)[0x%2B]/共%L行\ %4.p%%\ %10.y
" 关闭窗口/保存文件
map <leader>q	<Esc>:q!<CR>
map <C-u>	:update<CR>
imap <C-u>	<Esc>:update<CR>a
"自动补全括号
imap ( ()<ESC>i
imap { {}<ESC>i
imap [ []<ESC>i
vnoremap [p <esc>`>a]<esc>`<i[<esc>i
vnoremap (( <esc>`>a)<esc>`<i(<esc>i
vnoremap {{ <esc>`>a}<esc>`<i{<esc>i

map <expr> rcw Replace_Current_Word()
map <expr> <C-w> Replace_Current_Word()
"=========================
func Replace_Current_Word()
	let w = expand("<cword>")
	return "\<ESC>:%s/\\<".w."\\>/".w."/g\<Left>\<Left>"
endfun
"=========================
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
au BufNewFile *.bash	0put='#!/bin/bash'|setf bash|normal Go
au BufNewFile *.perl,*.pl	0put='#!/usr/bin/perl'|setf perl|normal Go
