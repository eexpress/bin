#!/bin/bash

alias gcc='/usr/bin/gcc `pkg-config --cflags --libs gtk+-3.0 gmodule-2.0`'
alias gccm3='arm-none-eabi-gcc -Os -mcpu=cortex-m3 -mthumb'
alias valac='/usr/bin/valac --pkg gtk+-3.0'
alias fc-zh='fc-list :lang=zh-cn family file|sed "s/:\ \(.*\)/\x1b[0;32m\t\1\x1b[0m/"'

#if [ -f '/usr/bin/aptitude' ]; then
apt=1
if [[ -f '/usr/bin/aptitude' && $apt -eq 1 ]]; then
	alias ai='sudo aptitude install'
	alias ap='sudo aptitude purge'
	alias ar='sudo aptitude remove'
	alias au='sudo aptitude update && msg 列表已经刷新 || msg 刷新失败'
	alias ag='sudo aptitude upgrade'
else
	alias ai='sudo apt-get install'
	alias ap='sudo apt-get purge'
	alias ar='sudo apt-get remove'
	alias au='sudo apt-get update && msg 列表已经刷新 || msg 刷新失败'
	alias ag='sudo apt-get upgrade'
fi
	alias aa='sudo apt-get autoremove'
	alias aw='aptitude show'
#    alias as='aptitude search'
#▶ aptitude search '!~nlib!~ri386!~v dock tool'
#p   autodocktools                        - GUI to help set up, launch and analyze AutoDock
#p   mgltools-pyautodock                  - Python implementation of autodock
as(){ aptitude search "!~nlib!~ri386!~v $*";}

alias cal='cal -3'
alias calendar='calendar -A 7'
alias ce='crontab -e'
alias cl='crontab -l'
alias cn='export LC_ALL=zh_CN.UTF-8'
alias en='export LC_ALL=C'

alias d='df -hT -x tmpfs -x devtmpfs'
alias tail='/usr/bin/tail -n $(($LINES-4))'
alias head='/usr/bin/head -n $(($LINES-4))'
alias dmesg='/bin/dmesg|tail|cut -b -$COLUMNS'
alias dog='grep -v -E "(^$|^#|^!)"'
alias free='free -m'
alias g='grep --color=always -inTZ 2>/dev/null'
#grep 结果的文件名后面跟的：或者null，需要处理
alias s='mplayer'
alias rm='gvfs-trash'
alias rmm='/bin/rm'
#alias less='less -R'
export LESS="--RAW-CONTROL-CHARS"
#alias less='/usr/share/vim/vim74/macros/less.sh'
alias hexdump='hexdump -C'
#export GREP_COLOR='1;37;42'
alias rsync='/usr/bin/rsync -Pau'

alias v='/usr/bin/gvim --remote-silent-tab'
#v() { /usr/bin/gvim -f  --remote-silent-tab \"$@\" &; }
alias sv='sudo /usr/bin/gvim --remote-silent-tab'
alias iftop.启动='sudo iftop -i `netname`'
alias k='pkill -9'
alias sk='sudo pkill -9'
alias lsm='ls -lAh -t'
alias lsc='ls -lAh -tc'
alias lss='ls -lAh -S'

alias ps='/bin/ps -e -o pid,command'
alias rm_empty_dir='find -type d -empty -exec rmdir {} \;'
alias ss5='gnome-screenshot --delay 5'
alias t.l='tar tf '
alias t.u='tar uPvf '
alias t.x='tar xmPvf '
#alias find-opera-1M='find ~/.opera/cache*/ -iname "opr*.tmp" -cmin -60 -size +1000k -printf "------\t%p\t► %Cr\t► %kK\t►" -exec file -b {} \;'
#alias tar-opera='t.u ~/opera-setting-`hostname`-`date '+%Y-%m-%d-%H-%M-%S'`.tar `find ~/.opera -iname "*.adr" -or -iname "*.ini" -or -iname "wand.dat" -or -iname "eexp*" -or -iname "*user.js"`'
netname(){ ip route|head -n 1|cut -d' ' -f 5; }
alias pl='perl -e'
alias plp='perl -pe'
pg(){ /bin/ps -e -o pid,command|grep $1|grep -v grep; }
#gitup(){ git ci -a -m "${*:-`date`}"; git remote|grep .; [ $? == 1 ] && return; git push; [ $? == 0 ] || git push httpsgithub; }
c(){ echo $1|bc -l; }
cdd(){ d=`dirname "$1"`; echo $d; cd "$d";}
nmap(){ /usr/bin/nmap ${1:-localhost}|grep open; }
p(){ ping -c 5 ${1:-www.163.com}; }
du(){ /usr/bin/du -sch "$@"|sort -rh; }
o(){ xdg-open ${1:-"`xsel -o|sed "s/\ /\\\ /g"|sed "s/\n.*//"`"}; }
#loc(){ locate -eLin $(($LINES-4)) -r "^`pwd`.*$1[^\/]*$"; }
fcnt(){ n=`ls --color=none -1 $*|wc -l`; echo "一共有 "$n" 个文件。"; }
pkg-depend(){ [ -z $1 ] || aptitude search ~i~D"\b$1\b" -F %p|tr -d ' '|tr '\n' ';'|sed 's/;$/\n/'; }
#--------TAB COMPLETION ADD------------------------
#        local cur; COMPREPLY=(); cur=`_get_cword`
_show_installed()
{ COMPREPLY=($(_xfunc dpkg _comp_dpkg_installed_packages `_get_cword`)); return 0; }
complete -F _show_installed $default ap ar

_show_all()
{ COMPREPLY=($(apt-cache pkgnames `_get_cword` 2> /dev/null)); return 0; }
complete -F _show_all $default aw ai as

#_grep_history()
#{ COMPREPLY=($(grep '^cd ' ~/.bash_history|sed 's/^cd\s*//'|grep '^[/~]'|grep `_get_cword` 2> /dev/null)); return 0; }
#alias t='cd'
#complete -F _grep_history t
_avahi_host()
{ COMPREPLY=($(avahi-browse -at|grep -v `hostname`|grep v4|cut -d' ' -f 5)); return 0; }
complete -F _avahi_host $default ssh

#complete -W "$(echo 'eexp@'$(avahi-browse -at|grep -v `hostname`|grep v4|cut -d' ' -f 5)'.local:')" ssh
#complete -W "$(echo $(grep '^ssh ' ~/.bash_history | sort -u | sed 's/^ssh //'))" ssh

#bind -x '"\C-l":ls -l'
#-------LESS TERMCAP-------------------------------
#The default pager for man is less. 
#this part effect only man. not for less.
#export LESS_TERMCAP_mb=$'\033[01;31m' 
#export LESS_TERMCAP_md=$'\033[01;31m' 
#export LESS_TERMCAP_me=$'\033[0m' 
#export LESS_TERMCAP_se=$'\033[0m' 
#export LESS_TERMCAP_so=$'\033[01;44m' 
#export LESS_TERMCAP_ue=$'\033[0m' 
#export LESS_TERMCAP_us=$'\033[01;32m'

export LESS_TERMCAP_mb=$(tput bold; tput setaf 1)
export LESS_TERMCAP_md=$(tput bold; tput setaf 1)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 2)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
#smul 下划线
#use vim as pager
#export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

#-------ENVIROMENT SET-----------------------------
export PATH=$HOME/bin:$PATH
export CDPATH=:~:~/bin
export RES=$HOME/bin/resources

#thiscolor=`expr $(printf "%d" "'$(hostname|cut -b 8)") % 3 + 1`
#thiscolor=`date +%u`
#PS1='\[\e[31;40m\]\D{%Y-%m-%d %H:%M:%S %a}\[\e[32;40m\] \w \[\e[m\]\n● '
pc0='\[\e[1;32;40m\]'
pc1='\[\e[1;37;42m\]'
PS1="$pc0\D{%Y-%m-%d %A} \t \H $pc1 \w \[\e[m\] \n▶ "
#PS1="\[\e[3$thiscolor;40m\]\D{%Y-%m-%d %a} \t \H \w \[\e[m\] \n▶ "
#PS1='\[\e[32;40m\]\D{%Y-%m-%d %a} \t \H \w \[\e[m\] \n● '

#-------HISTORY------------------------------------
shopt -s histappend
PROMPT_COMMAND='history -a'

PS4='+{$LINENO:${FUNCNAME[0]}} '
HISTFILESIZE=2000
HISTSIZE=2000
HISTTIMEFORMAT='%F %T '
HISTCONTROL=erasedups
HISTIGNORE="pwd:ls:cd:"

bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

. /usr/share/autojump/autojump.bash
