#!/bin/bash

#-------ALIAS------------------------------------
alias dog='grep -v -E "(^$|^#|^!)"'
alias ps='/bin/ps -u `id -un` -o pid,command'
alias pg='pgrep -af'

alias g='grep --color=always -Pi 2>/dev/null'
alias k='pkill -9 -f'

##			-------- LS --------
alias l='\ls --color=auto'
alias la='l -A'
alias lt='l -oAh  --time-style=iso -t'		# mtime
alias ls='lt -S'		# size

#-------PS1 COLOR----------------------------------
	darkgreen="0x16"	#dark green
	gray="0xee"	#light gray
	red="0xa0"
	green_gray=`tput setaf 2; tput setab $gray;`
	allgray=`tput setaf $gray; tput setab $gray;`
	gray_green=`tput setaf 0xfa; tput setab $darkgreen;`
	gray_red=`tput setaf 0xfa; tput setab $red;`
	allgreen=`tput setaf $darkgreen; tput setab $darkgreen;`
	allred=`tput setaf $red; tput setab $red;`
	setbold=`tput bold;`
	setnone=`tput sgr0`
	PS1="$setbold$gray_green \D{%F %A %T}$allgreen🡺$green_gray  \H $allgray🡺$gray_red  \w$allred🡺$setnone \n🔴 "

#-------HISTORY------------------------------------
shopt -s histappend
PROMPT_COMMAND='history -a'

bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

