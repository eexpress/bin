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

alias d='/usr/bin/df -hT -x tmpfs -x devtmpfs'
alias f='free -h|cut -b -43'
alias g='grep --color=always -Pi'
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

alias dl="$HOME/bin/you-get/you-get"
alias dlp="$HOME/bin/you-get/you-get -p mplayer"
alias dl0="$HOME/bin/you-get/you-get -s 127.0.0.1:1080 -c '/home/eexpss/.mozilla/firefox/e8fczwpf.default/cookies.sqlite'"

pg(){ /bin/ps -e -o pid,command|grep $1|grep -v grep; }
c(){ echo $1|bc -l; }
cdd(){ d=`dirname "$1"`; echo $d; cd "$d";}
p(){ ping -c 5 ${1:-www.163.com}; }
o(){ xdg-open ${1:-"`xclip -o|sed -e "s.^~.$HOME." -e "s/\ /\\\ /g" -e "s/\n.*//"`"}; }
s(){ highlight --force -O ansi $1 | /usr/bin/less -iR; }
u(){ /usr/bin/du -sch "$@"|sort -rh; }

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
export CDPATH=:~:~/bin
pc0='\[\e[1;32;40m\]'
pc00=`tput bold; tput setaf 2; tput setab 0;`
pc1='\[\e[1;37;42m\]'
pc01=`tput bold; tput setaf 7; tput setab 2;`
pc2='\[\e[m\]'
pc02=`tput sgr0`
PS1="$pc00\D{%Y-%m-%d %a} \t \H $pc01 \w $pc02 \n▶ "

#-------HISTORY------------------------------------
shopt -s histappend
PROMPT_COMMAND='history -a'

bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

#unset command_not_found_handle
. /usr/share/autojump/autojump.bash
