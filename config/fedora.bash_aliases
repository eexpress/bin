#!/bin/bash

set -o vi

#-------ALIAS------------------------------------
alias di='sudo dnf install'
alias dr='sudo dnf remove'
alias du='sudo dnf update'
alias da='sudo dnf autoremove'
alias ds='dnf search'
alias dinfo='dnf info'
alias dfile='dnf repoquery -l'
alias dfile1='rpm -q --filesbypkg'
alias dh='sudo dnf history'

alias cn='export LC_ALL=zh_CN.UTF-8'
alias en='export LC_ALL=C'
alias fc-zh='fc-list :lang=zh-cn family file|sed "s,/.*/,,"|sed "s/:\ \(.*\)/\x1b[0;32m\t\1\x1b[0m/"'
alias tail='/usr/bin/tail -n $(($LINES-4))'
alias head='/usr/bin/head -n $(($LINES-4))'
alias dog='grep -v -E "(^$|^#|^!)"'
alias hexdump='hexdump -C|cut -b 9-'
alias axel='/usr/bin/axel -n 10 -a'
alias myip='curl ipinfo.io'
alias ps='/bin/ps -u `id -un` -o pid,command'
alias pl='perl -ple'

alias d='df -hT -x tmpfs -x devtmpfs -x vfat'
alias f='free -h|cut -b -43'
alias g='grep -P'
#alias g='grep --color=always -inTZE 2>/dev/null'
alias v='/usr/bin/gvim --remote-silent-tab'
alias sv='sudo /usr/bin/gvim --remote-silent-tab'
alias k='pkill -9 -f'
alias l='ls'
alias la='ls -a'

alias lsm='ls -oAh --time-style=iso -t'
alias lsc='ls -oAh --time-style=iso -tc'
alias lss='ls -oAh --time-style=iso -S'

alias hexo='cd ~/磁盘/eexp/文档/blog.hexo;/usr/bin/hexo'
alias git='cd ~/bin;/usr/bin/git'

pg(){ /bin/ps -e -o pid,command|grep $1|grep -v grep; }
c(){ echo $1|bc -l; }
cdd(){ d=`dirname "$1"`; echo $d; cd "$d";}
p(){ ping -c 5 ${1:-www.163.com}; }
o(){ xdg-open ${1:-"`xsel -o|sed -e "s.^~.$HOME." -e "s/\ /\\\ /g" -e "s/\n.*//"`"}; }

#-------LESS TERMCAP for color manpage------------
export LESS_TERMCAP_mb=$(tput bold; tput setaf 1)	# begin blinking          	
export LESS_TERMCAP_md=$(tput bold; tput setaf 1)	# begin bold
export LESS_TERMCAP_me=$(tput sgr0)					# end mode
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)	# begin standout-mode
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)		# end standout-mode - info box
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 2)	# begin underline
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)		# end underline
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export MANPAGER="/usr/bin/less"
export GROFF_NO_SGR=1	#fix no color in Fedora 25

#-------ENVIROMENT SET-----------------------------
export PATH=$HOME/bin:$PATH
export CDPATH=:~:~/bin
pc0='\[\e[1;32;40m\]'
pc1='\[\e[1;37;42m\]'
pc2='\[\e[m\]'
PS1="$pc0\D{%Y-%m-%d %a} \t \H $pc1 \w $pc2 \n▶ "

#-------HISTORY------------------------------------
shopt -s histappend
PROMPT_COMMAND='history -a'

bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

. /usr/share/autojump/autojump.bash
