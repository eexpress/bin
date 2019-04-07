#!/bin/bash

set -o vi

#-------ALIAS------------------------------------
alias dog='grep -v -E "(^$|^#|^!)"'
alias ps='/bin/ps -u `id -un` -o pid,command'
alias pg='pgrep -af'

alias g='grep --color=always -Pi 2>/dev/null'
alias v='/usr/bin/gvim --remote-tab'
alias k='pkill -9 -f'

alias ls='/usr/bin/ls --color=auto'
alias l='ls'
alias la='ls -a'
alias lsm='ls -oAh --time-style=iso -t'		# mtime
alias lsc='ls -oAh --time-style=iso -tc'	# ctime
alias lss='ls -oAh --time-style=iso -S'		# size

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

