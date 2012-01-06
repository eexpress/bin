" 开启语法高亮
syntax on 
colo desert
set ai
set t_Co=256
set nu
set autochdir
" 搜索忽略大小写
set ignorecase
" 设置文字编码自动识别
set encoding=utf-8
set fencs=utf-8,gb18030,gbk
set guifont=Vera\ Sans\ YuanTi\ Mono
"set guifont=Courier\ 10\ Pitch\ 11
"colorscheme eexp
colorscheme desert
" 使用鼠标，排除普通模式，则在普通模式下选择文字，可中键粘贴出去。
set mouse=vic
set mouse=a
" 设置高亮搜索
set hlsearch
" 输入字符串就显示匹配点
set incsearch
" 输入的命令显示出来，看的清楚些。
set showcmd
" 打开当前目录文件列表
map <F3> :tabnew .<CR>
" 函数和变量列表
map <F4> :TlistToggle<CR>
" Tlist的内部变量。函数列表。
let Tlist_Use_Right_Window=1
let Tlist_File_Fold_Auto_Close=1
" 在当前目录搜索当前词，并打开quickfix窗口
map <F5> :call Search_Word()<CR>
" 显示tags的当前词的定义
noremap <F6> :call ShowDefine()<CR>
" 全能补全
inoremap <F8> <C-x><C-o>
" 设置程序运行
map <F9> :call CompileRun()<CR>
" 直接运行
"map <F10> :!%<CR>
" 关闭窗口，保存文件
map <leader>q	:q!<CR>
imap <leader>q	<Esc>:q!<CR>
map <C-u>	:update<CR>
imap <C-u>	<Esc>:update<CR>a
"自动补全括号
imap ( ()<ESC>i
imap { {}<ESC>i
imap [ []<ESC>i

vnoremap [p <esc>`>a]<esc>`<i[<esc>i
vnoremap (( <esc>`>a)<esc>`<i(<esc>i
vnoremap {{ <esc>`>a}<esc>`<i{<esc>i

imap <TAB> <C-p>
"新脚本自动加类型
autocmd BufNewFile *.bash	0put='#!/bin/bash'|setf bash|normal Go
au BufNewFile *.perl,*.pl	0put='#!/usr/bin/perl'|setf perl|normal Go
au BufNewFile,BufRead *.c so ~/.vim/echofunc.vim
" Vala
autocmd BufRead *.vala set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
au BufRead,BufNewFile *.vala            setfiletype vala
let vala_comment_strings = 1
let vala_space_errors = 1
let vala_no_tab_space_error = 1

"状态栏
set laststatus=2
set statusline=
set statusline+=%-20f
set statusline+=%10.{&encoding}
set statusline+=\ \ \ \ (%3.l,%3.c)[0x%2B]/共%L行\ %4.p%%\ %10.y

func CompileRun() 
exec "w" 
if &filetype == 'c' 
exec "!/usr/bin/gcc `pkg-config --cflags --libs gtk+-2.0 gmodule-2.0` % -g -o %<.run" 
exec "!./%<.run" 
elseif &filetype == 'perl' 
exec "!perl %" 
elseif &filetype == 'tex' 
exec "!xelatex %; [ $? == 0 ] && nohup evince %:r.pdf; nohup rm *.aux *.log *.snm *.nav *.out *.toc"
endif 
endfunc

"============= Folding configuration ============
"set foldopen=all	" 光标进入，自动打开折叠
"set foldclose=all	" 光标退出，自动关闭折叠
"set foldlevel=2
autocmd BufRead *.c set foldmethod=syntax 	" 设置语法折叠
autocmd BufRead *.perl,*.pl set foldmethod=indent	"缩进折叠
set tabstop=4
set shiftwidth=4
"手动创建折叠，zf zd 缺省标记/*{{{*/，不适合Perl
"autocmd BufRead *.perl,*.pl set foldmethod=marker
set foldcolumn=3 	"设置折叠区域的宽度
set foldminlines=4
nnoremap <space> @=((foldclosed(line('.'))<0)?'zc':'zo')<CR>
                            " 用空格键来开关折叠
set foldenable!
" 共享剪贴板
"set clipboard+=unnamed

set list
set listchars=tab:\|\ 
map rj !!date<CR>
"nm <silent> tt :!ctags -R --fields=+lS .<CR>

"2010年 10月 16日 星期六 17:49:17 CST
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

"nmap cs :cs find s <C-R>=expand("<cword>")<CR><CR>
"nmap cg :cs find g <C-R>=expand("<cword>")<CR><CR>
"nmap cc :cs find c <C-R>=expand("<cword>")<CR><CR>
"nmap ct :cs find t <C-R>=expand("<cword>")<CR><CR>
"nmap ce :cs find e <C-R>=expand("<cword>")<CR><CR>
"nmap cf :cs find f <C-R>=expand("<cfile>")<CR><CR>
"nmap ci :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"nmap cd :cs find d <C-R>=expand("<cword>")<CR><CR>
"s: 查找C语言符号，即查找函数名、宏、枚举值等出现的地方
"g: 查找函数、宏、枚举等定义的位置，类似ctags所提供的功能
"d: 查找本函数调用的函数
"c: 查找调用本函数的函数
"t: 查找指定的字符串
"e: 查找egrep模式，相当于egrep功能，但查找速度快多了
"f: 查找并打开文件，类似vim的find功能
"i: 查找包含本文件的文件

"0 or s: Find this C symbol
"1 or g: Find this definition
"2 or d: Find functions called by this function
"3 or c: Find functions calling this function
"4 or t: Find this text string
"6 or e: Find this egrep pattern
"7 or f: Find this file
"8 or i: Find files #including this file

