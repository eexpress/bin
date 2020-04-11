#!/bin/bash

set -o vi

export VGL_LOGO=1	# Bumbleebee显示右下角VGL标记
#-------ALIAS------------------------------------
##			-------- 软件包管理 --------
if [ -x /usr/bin/apt ]; then
	alias pi='sudo apt install'
	alias pr='sudo apt remove'
	alias pu='sudo apt update && sudo apt upgrade'
	alias pf='apt list'			# 搜索包名
	alias pfi='apt list --installed'	# 搜索已安装的包。
	alias pf0='apt search'			# 搜索描述，参数是AND关系。
#	alias pfile='dpkg -S '			# 文件所属的包
	pfile(){ dpkg -S $@ || apt-file search $@; }	# 查找文件所属的包(已安装/未安装)
	alias pinfo='apt show'
#	alias plist='dpkg -L'
	plist(){ dpkg -L $@ || apt-file list $@; }	# 列出包的文件(已安装/未安装)
	#as(){ aptitude search "!~nlib!~ri386!~v $*";}
else
	alias pi='sudo dnf install'
	alias pr='sudo dnf remove'
	alias pu='sudo dnf update'
	#alias pu='sudo dnf update --exclude="botan2"'
	##			-------- 未安装的包 --------
	# -C 完全从系统缓存运行。长期bug: 1247644。每次都提示导入 GPG 公钥。
	pf(){ dnf search -Cy $@|gc $@; }	# 无安装状态。搜索参数是AND关系。
	pfi(){ dnf list installed "*$1*$2*$3*"|gc $@; }	# 搜索已安装的包。
	#alias pinf0='dnf info -Cy'			# 可通配符查未安装的包说明
	##			-------- 已安装的包 --------
	alias pfile='rpm -q --file'				# 文件所属的包
	alias pneed='rpm -q --whatrequires'		# 被哪个包需要
	# 包信息。rpm需要已安装的确切包名；dnf可通配符查未安装的包。
	pinfo(){ rpm -q --info $1 || dnf info -Cy $1; }
	# 包的文件列表。
	plist(){ rpm -q --list $1 || dnf repoquery -Cy --list $1; }
fi
##------- ---------
alias ps='\ps -u `id -un` -o pid,command'
alias pg='pgrep -af'
alias k='pkill -u `id -un` -9 -f'

alias cn='export LC_ALL=zh_CN.UTF-8'
alias en='export LC_ALL=C'
alias fc-zh='fc-list :lang=zh-cn family file|sed "s,/.*/,,"|sed "s/:\ \(.*\)/\x1b[0;32m\t\1\x1b[0m/"'

alias g='grep --color=always -Pi 2>/dev/null'
alias tail='/usr/bin/tail -n $(($LINES-4))'
alias head='/usr/bin/head -n $(($LINES-4))'
alias dog='grep -v -E "(^$|^#|^!)"'
alias pl='perl -pe'
alias pln='perl -ne'

ocr(){ tesseract "$1" /tmp/ocr -l chi_sim 2>/dev/null && cat /tmp/ocr.txt; }

alias i='df -hT -x tmpfs -x devtmpfs -x squashfs|sed "/\/boot/D";echo -e "\n内存---------------";free -h|cut -b -43;echo -e "\n温度---------------";sensors|grep Core'
alias e='gedit'
if [ -x /usr/bin/io.elementary.code ]; then alias e='io.elementary.code'; fi
alias v='gvim --remote-tab-silent'
alias sv='sudo gvim'
alias du='\du -hs 2>/dev/null'

##			-------- LS --------
alias l='\ls --color=auto'
alias la='l -A'
alias lt='l -oAh  --time-style=iso -t'		# mtime
alias ls='lt -S'		# size

#-------FUNC------------------------------------
c(){ echo $1|bc -l; }
# 鼠标选择路径或文件，快速进入目录。
d(){ c=`xclip -o|sed -e "s.^~.$HOME."`; if [ -f "$c" ]; then d=`dirname "$c"`; else d=$c; fi; echo $d; cd "$d";}
p(){ ping -c 5 ${1:-www.163.com}; }
u(){ \du -sch "$@"|sort -rh; }

TERM=xterm-256color	# 放在所有tput之前。

#-------LESS TERMCAP for color manpage------------
#0=black 1=red 2=green 3=yellow 4=blue 5=magenta 6=cyan 7=white
#man terminfo: set_a_foreground -> setaf; set_a_background -> setab;
export LESS_TERMCAP_mb=$(tput bold; tput setaf 1)	# enter_bold_mode
export LESS_TERMCAP_md=$(tput bold; tput setaf 1)	# begin bold
export LESS_TERMCAP_me=$(tput sgr0)					# exit_attribute_mode
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)		# exit_standout_mode
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 2)	# enter_underline_mode
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)		# exit_underline_mode
export LESS_TERMCAP_mr=$(tput rev)		# enter_reverse_mode
export LESS_TERMCAP_mh=$(tput dim)		# enter_dim_mode (half-bright)
export MANPAGER="/usr/bin/less"
export GROFF_NO_SGR=1	#fix no color in Fedora 25

#-------ENVIROMENT SET-----------------------------
export PATH=$HOME/bin:$PATH
export CDPATH=:~:~/bin:~/文档

#-------PS1 COLOR----------------------------------
if [ "$(whoami)" == "root" ]; then psch="🔴"; else psch="⭕"; fi
	darkgreen="0x16"	#dark green
	gray="0xee"	#light gray
	green_gray=`tput setaf 2; tput setab $gray;`
	allgray=`tput setaf $gray; tput setab $gray;`
	gray_green=`tput setaf 0xfa; tput setab $darkgreen;`
	allgreen=`tput setaf $darkgreen; tput setab $darkgreen;`
	setbold=`tput bold;`
	setnone=`tput sgr0`
	PS1="$setbold$gray_green \D{%F %A %T}$allgreen🡺$green_gray  \H $allgray🡺$gray_green  \w$allgreen🡺$setnone \n$psch "
#⚠️

#-------HISTORY------------------------------------
shopt -s histappend
PROMPT_COMMAND='history -a'

bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

#bash_completion
. /etc/profile.d/bash_completion.sh
#unset command_not_found_handle
