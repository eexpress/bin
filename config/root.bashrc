#!/bin/bash

#-------ALIAS------------------------------------
##			-------- 软件包管理 --------
if [ -x /usr/bin/apt ]; then
	alias pi='apt install'
	alias pr='apt remove'
	alias pu='apt update && apt upgrade'
	alias pf='apt list'			# 搜索包名
	alias pfi='apt list --installed'	# 搜索已安装的包。
	alias pf0='apt search'			# 搜索描述，参数是AND关系。
	alias pinfo='apt show'
	alias plist='dpkg -L'
	#as(){ aptitude search "!~nlib!~ri386!~v $*";}
else
	alias pi='dnf install'
	alias pr='dnf remove'
	alias pu='dnf update'
	#alias pu='dnf update --exclude="botan2"'
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
alias g='grep --color=always -Pi 2>/dev/null'
alias e='gedit'

##			-------- LS --------
alias l='\ls --color=auto'
alias la='l -A'
alias lt='l -oAh  --time-style=iso -t'		# mtime
alias ls='lt -S'		# size

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
