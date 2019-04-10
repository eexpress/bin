colo evening 		" 配色主题	desert
set guifont=Input\ Mono\ Italic\ 15
set guifont=Fira\ Mono\ 15
set number 			" 显示行号
set mouse=a
set ignorecase		" 搜索忽略大小写
set incsearch		" 输入字符串就显示匹配点
set tabstop=4
set shiftwidth=4 	" < > 平移
set noexpandtab
set autoindent
set foldmethod=indent
set foldlevel=9
"indent 	"相同缩进的行折叠。zc/zo/zR(reset)
"mark: 设置 me 回来 'e/`e
"`gd` : Goto local Declaration.  "比*更直接的找到定义处。
"Ctrl-o/i 跳回去
set autoread 	"文件在Vim之外修改过，自动重新读入
filetype plugin on		"运行vim加载文件类型插件
"bn bp: buffer切换上下文件
set autochdir

" 关闭窗口/保存文件
map <leader>q	<Esc>:q!<CR>
map <C-u>	:update<CR>
imap <C-u>	<Esc>:update<CR>a
"水平垂直拆分窗口
"C-W split/vsplit/close(saft)/4个方向切换焦点

"======== Insert模式，输入时自动补全括号 ========
imap ( ()<ESC>i
imap { {}<ESC>i
imap [ []<ESC>i
"======== Visual模式，选择文字，用括号包起 ========
vmap (( <esc>`>a)<esc>`<i(<esc>i
vmap {{ <esc>`>a}<esc>`<i{<esc>i
vmap ** <esc>`>a*<esc>`<i*<esc>i
"======== Mimetype 新脚本自动加类型============
au BufNewFile *.bash,*.sh	0put='#!/bin/bash'|setf bash|normal Go
au BufNewFile *.perl,*.pl	0put='#!/usr/bin/perl'|setf perl|normal Go
autocmd BufRead,BufNewFile *.vala,*.vapi setfiletype vala

"======== 智能tab，补全或输入TAB ========
inoremap <expr> <Tab> MyTab()
fun MyTab()
	let str=strpart(getline("."), 0, col(".")-1)
	if str!="" && str=~'\m\w$'
		return "\<C-N>"
	endif
	return "\t"
endfun
"======== <F2> 使用devhelp查询当前词 ========
map <F2> :call Devhelp()<CR>
func Devhelp()
	let w = expand("<cword>")
	exec "!devhelp -s ".w."&"
endfunc
"======== <F4> 全局替换当前单词 ========
map <expr> <F4> Replace_Current_Word()
func Replace_Current_Word()
	let w = expand("<cword>")
	return "\<ESC>:%s/\\<".w."\\>/".w."/g\<Left>\<Left>"
endfun
"======== <F5> 运行前五行注释中的命令 ========
map <F5> :call RunComment()<CR>
func RunComment()
	let n = 1
	while n < 5
		let l=getline(n)
		if l =~ '//!'
			echo strpart(l, stridx(l, "!"))
			exec strpart(l, stridx(l, "!"))
			if v:shell_error
				echo "============= exec error !!! ============="
				break
			endif
		endif
		let n = n + 1
	endwhile
endfunc
"======= 修改vimrc后立刻load载入生效 =========
map <F8>	<Esc>:source ~/.vimrc<CR>
