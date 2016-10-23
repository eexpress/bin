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
" 设置文字编码自动识别
set encoding=utf-8
set fencs=utf-8,gb18030,gbk
set guifont=Courier\ 10\ Pitch\ 12,Courier\ New\ 12,Vera\ Sans\ YuanTi\ Mono\ 12
" 设置高亮搜索
set hlsearch
set incsearch		" 输入字符串就显示匹配点
set tabstop=4
set shiftwidth=4
"set list
"set listchars=tab:\|\ 
"状态栏
set laststatus=2
set statusline=
set statusline+=%-20f
set statusline+=%10.{&encoding}
set statusline+=\ \ \ \ (%3.l,%3.c)[0x%2B]/共%L行\ %4.p%%\ %10.y
"CTRL+X CTRL+I 头文件补全
"set path=/usr/lib/avr/include

"============= Map ============
" 打开当前目录文件列表
map <F3> :tabnew .<CR>
" 函数和变量列表
map <F4> :TlistToggle<CR>
map <F4> :TagbarToggle<CR>
" Tlist的内部变量。函数列表。
let Tlist_Use_Right_Window=1
let Tlist_File_Fold_Auto_Close=1
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

imap <C-t> "<C-R>=strftime("%Y_%m_%d-%H:%M")<CR>"
map <C-s> :sp<CR>
"============= Mimetype ============
"新脚本自动加类型
au BufNewFile *.bash	0put='#!/bin/bash'|setf bash|normal Go
au BufNewFile *.perl,*.pl	0put='#!/usr/bin/perl'|setf perl|normal Go
"au BufNewFile,BufRead *.c so ~/.vim/echofunc.vim
" Vala
autocmd BufRead *.vala set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
au BufRead,BufNewFile *.vala setfiletype vala
au BufRead,BufNewFile *.md se ft=slide

let vala_comment_strings = 1
let vala_space_errors = 1
let vala_no_tab_space_error = 1

"============= Function Define ============
map <F9> :call CompileRun()<CR>
func CompileRun() 
	exec "w" 
	if &filetype == 'c' 
	exec "!/usr/bin/gcc `pkg-config --cflags --libs gtk+-2.0 gmodule-2.0` % -g -o %<.run" 
	exec "!./%<.run" 
	elseif &filetype == 'perl' 
	exec "!perl %" 
	elseif &filetype == 'tex' 
	exec "!xelatex \'%\'; [ $? == 0 ] && nohup evince %:r.pdf >/dev/null 2>&1 &"
	elseif &filetype == 'markdown'
"    exec "!multimarkdown \'%\'>\'%.html\'; [ $? == 0 ] && nohup opera -activetab \'%.html\' >/dev/null 2>&1 &"
"    exec "!multimarkdown \'%\'>\'%.html\'; [ $? == 0 ] && nohup xdg-open \'%.html\' >/dev/null 2>&1 &"
	exec "!multimarkdown \'%\'>\'%.html\'; [ $? == 0 ] && wkhtmltopdf --user-style-sheet mkd.css \'%.html\' \'%.pdf\'; evince \'%.pdf\' &"
	elseif &filetype == 'dot'
	exec "!dot -Tsvg % -o %.svg; eog %.svg"
	elseif &filetype == 'vala'
	exec "!valac --pkg gtk+-3.0 %; [ $? -eq 0 ] && ./%:t:r"
	elseif &filetype == 'slide'
	exec "!pandoc \'%\' -o \'%.html\' -t revealjs -s -V transition=cube -V theme=default; [ $? -eq 0 ] && nohup xdg-open \'%.html\' >/dev/null 2>&1 &"
	endif 
endfunc

map avr :!./avr.sh main.c<CR>
map dot :!~/bin/flow.pl %<CR>

map <expr> rcw Replace_Current_Word()
map <expr> <C-w> Replace_Current_Word()
func Replace_Current_Word()
	let w = expand("<cword>")
	return "\<ESC>:%s/\\<".w."\\>/".w."/g\<Left>\<Left>"
endfun

" 在当前目录搜索当前词，并打开quickfix窗口
au BufRead *.pl,*.perl,*.c,*.h,*.bash map <expr> <C-f> Search_Word_In_Dir()
func Search_Word_In_Dir()
	let w = expand("<cword>")      " 在当前光标位置抓词
	let e = expand("%:p:e")      " 取得当前文件的类型
	return ":vimgrep /\\<".w."\\>/ *.".e."\<CR>:copen\<CR>"
endfun

inoremap <expr> <Tab> MyTab()
fun MyTab()
	let str=strpart(getline("."), 0, col(".")-1)
	if str!="" && str=~'\m\w$'
		return "\<C-N>"
	endif
	return "\t"
endfun

"============= Folding configuration ============
"set foldopen=all	" 光标进入，自动打开折叠
"set foldclose=all	" 光标退出，自动关闭折叠
"set foldlevel=2
set foldmethod=indent	"缩进折叠
autocmd BufRead *.c set foldmethod=syntax 	" 设置语法折叠
"autocmd BufRead *.perl,*.pl set foldmethod=indent	"缩进折叠
"autocmd BufRead *.vala set foldmethod=indent	"缩进折叠
"手动创建折叠，zf zd 缺省标记/*{{{*/，不适合Perl
"autocmd BufRead *.perl,*.pl set foldmethod=marker
set foldcolumn=3 	"设置折叠区域的宽度
set foldminlines=4
nnoremap <space> @=((foldclosed(line('.'))<0)?'zc':'zO')<CR>
                            " 用空格键来开关折叠
set foldenable!

"============= Ctags && Cscope ============
"ctags 主要用于补全 CTRL-]/T。 cscope 主要用于阅读调用关系。
set tags=tags;		" 递归查找ctags
nm <silent> ctag :!ctags -R --fields=+lS .<CR>
"cscope的路径里面不能有空格。
nm <silent> cscope :!cscope -Rbkq<CR><CR>:cs add cscope.out<CR>
" cscope setting
"● cscope -Rbkq
if has("cscope")
	set csprg=/usr/bin/cscope
	set csto=1
	set cst
	set nocsverb
	" add any database in current directory
	if filereadable("cscope.out")
		  cs add cscope.out
	endif
	set csverb
endif

"列出出现的位置
nmap <leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>
"查找定义，相当于ctags的CTRL-]，返回都是CTRL-T
nmap <leader>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <leader>cs :cs help find<CR>
"s: 查找C语言符号，即查找函数名、宏、枚举值等出现的地方
"g: 查找函数、宏、枚举等定义的位置，类似ctags所提供的功能
"d: 查找本函数调用的函数
"c: 查找调用本函数的函数
"t: 查找指定的字符串
"e: 查找egrep模式，相当于egrep功能，但查找速度快多了
"f: 查找并打开文件，类似vim的find功能
"i: 查找包含本文件的文件

