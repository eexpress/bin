#!/bin/bash

set -o vi
#alias gcc='/usr/bin/gcc `pkg-config --cflags --libs gtk+-3.0 gmodule-2.0`'
#alias gccm3='arm-none-eabi-gcc -Os -mcpu=cortex-m3 -mthumb'
#alias valac='/usr/bin/valac --pkg gtk+-3.0'
alias fc-zh='fc-list :lang=zh-cn family file|sed "s,/.*/,,"|sed "s/:\ \(.*\)/\x1b[0;32m\t\1\x1b[0m/"'
#alias fc-zh1='fc-list :lang=zh-cn family file|sed "s,/.*/,,"|awk -F: '\''{printf "%30s  \x1b[0;32m%s\x1b[0m\n",$1,$2;}'\'''


# Use `apt` instead of `aptitude` when 2016.
	alias ai='sudo apt install'
	alias ap='sudo apt purge'
	alias au='sudo apt update && msg 列表已经刷新 || msg 刷新失败'
	alias ag='sudo apt upgrade'
	alias as='apt list'
	alias aw='apt show'
	alias aa='sudo apt autoremove'
#as(){ aptitude search "!~nlib!~ri386!~v $*";}

#alias cal='cal -3'
#alias calendar='calendar -A 7'
#alias ce='crontab -e'
#alias cl='crontab -l'
alias cn='export LC_ALL=zh_CN.UTF-8'
alias en='export LC_ALL=C'

alias d='df -hT -x tmpfs -x devtmpfs -x vfat'
alias tail='/usr/bin/tail -n $(($LINES-4))'
alias head='/usr/bin/head -n $(($LINES-4))'
#alias dmesg='/bin/dmesg|tail|cut -b -$COLUMNS'
alias dog='grep -v -E "(^$|^#|^!)"'
alias f='free -h|cut -b -43'
alias g='grep --color=always -inTZ 2>/dev/null'
alias m='gnome-system-monitor'
#grep 结果的文件名后面跟的：或者null，需要处理
#alias s='mplayer'
alias x='gvfs-trash'
#alias rmm='/bin/rm'
#alias unzip='unzip -O CP936'
alias hexdump='hexdump -C|cut -b 9-'
#alias rsync='/usr/bin/rsync -Pau'
#alias web='python -m SimpleHTTPServer'
#alias ffmpeg='/usr/bin/ffmpeg -hide_banner 2>&1'
#alias ffprobe='/usr/bin/ffprobe -hide_banner 2>&1'

alias v='/usr/bin/gvim --remote-silent-tab'
alias sv='sudo /usr/bin/gvim --remote-silent-tab'
alias n='speedometer -r `netname` -k 256 -i 0.5'
#alias iftop.启动='sudo iftop -i `netname`'
alias k='pkill -9 -f'
#alias sk='sudo pkill -9'
alias lsm='ls -oAh --time-style=iso -t'
alias lsc='ls -oAh --time-style=iso -tc'
alias lss='ls -oAh --time-style=iso -S'

alias ps='/bin/ps -u `id -un` -o pid,command'
#alias rm_empty_dir='find -type d -empty -exec rmdir {} \;'
alias ss5='gnome-screenshot --delay 5'
#alias find-opera-1M='find ~/.opera/cache*/ -iname "opr*.tmp" -cmin -60 -size +1000k -printf "------\t%p\t► %Cr\t► %kK\t►" -exec file -b {} \;'
#alias tar-opera='t.u ~/opera-setting-`hostname`-`date '+%Y-%m-%d-%H-%M-%S'`.tar `find ~/.opera -iname "*.adr" -or -iname "*.ini" -or -iname "wand.dat" -or -iname "eexp*" -or -iname "*user.js"`'
netname(){ ip route|head -n 1|cut -d' ' -f 5; }
alias pl='perl -pe'
#alias plp='perl -pe'
pg(){ /bin/ps -e -o pid,command|grep $1|grep -v grep; }
#gitup(){ git ci -a -m "${*:-`date`}"; git remote|grep .; [ $? == 1 ] && return; git push; [ $? == 0 ] || git push httpsgithub; }
c(){ echo $1|bc -l; }
cdd(){ d=`dirname "$1"`; echo $d; cd "$d";}
nmap(){ /usr/bin/nmap ${1:-localhost}|grep open; }
p(){ ping -c 5 ${1:-www.163.com}; }
du(){ /usr/bin/du -sch "$@"|sort -rh; }
o(){ xdg-open ${1:-"`xsel -o|sed "s/\ /\\\ /g"|sed "s/\n.*//"`"}; }
#loc(){ locate -eLin $(($LINES-4)) -r "^`pwd`.*$1[^\/]*$"; }
#fcnt(){ n=`ls --color=none -1 $*|wc -l`; echo "一共有 "$n" 个文件。"; }
#-------LESS TERMCAP for color manpage------------
export LESS_TERMCAP_mb=$(tput bold; tput setaf 1)
export LESS_TERMCAP_md=$(tput bold; tput setaf 1)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 2)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
#-------ENVIROMENT SET-----------------------------
export PATH=$HOME/bin:$PATH
export CDPATH=:~:~/bin
#export RES=$HOME/bin/resources
pc0='\[\e[1;32;40m\]'
pc1='\[\e[1;37;42m\]'
PS1="$pc0\D{%Y-%m-%d %A} \t \H $pc1 \w \[\e[m\] \n▶ "
#--------TAB COMPLETION ADD------------------------
_show_installed()
{
        local cur; COMPREPLY=(); cur=`_get_cword`
        COMPREPLY=( $( _xfunc dpkg _comp_dpkg_installed_packages $cur ) )
        return 0
}
_show_all()
{
        local cur; COMPREPLY=(); cur=`_get_cword`
        COMPREPLY=( $( apt-cache pkgnames $cur 2> /dev/null ) )
        return 0
}
complete -F _show_all $default aw ai as
complete -F _show_installed $default ap
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
