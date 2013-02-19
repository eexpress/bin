#!/bin/bash

greenB='\x1b[1;32m'; end='\x1b[0m'; redB='\x1b[1;31m'; blueB='\x1b[1;34m'
m=`basename "$0"`
cd "`dirname "$0"`"
d=`pwd|sed "s.^$HOME/.\\$HOME/."` #使用缩写
echo -e "${blueB}WorkDir:${end}\n$d\t$m"
#exit
i=0
for f in *; do
	if [ $f != $m ]; then #排除自身
	echo $f|grep -q '^_'
		if [ $? -eq 1 ]; then #跳过前缀_的文件
		while [ -L $f ]; do f=`readlink $f`; done #追溯链接
		echo $f|grep -q '^/'
		if [ $? -eq 1 ]; then f="$d/$f"; fi #附加路径
		arrays[$i]="$f" #追加数组
		((i++))
		fi
	fi
done
echo -e "${greenB}Append those source files to ~/.bashrc:${end}"
echo ${arrays[@]}
echo -e "${redB}env:${end}"
a=`set|grep arrays`
echo $a
#exit
sed -i '/--eexp--/,+3 d' ~/.bashrc
#sed -i '/--eexp--/,$ d' ~/.bashrc
echo '#-----------eexp---------'>>~/.bashrc
echo 'set -o vi'>>~/.bashrc
echo $a|sed 's/\"\\/"/g'>>~/.bashrc
echo 'for prg in ${arrays[@]}; do [ -f "$prg" ] && . $prg; done; unset prg;'>>~/.bashrc
echo -e "${blueB}append result:${end}"
sed -n '/--eexp--/,$ p' ~/.bashrc
#-----------eexp---------
#set -o vi
#arrays=([0]="$HOME/bin/bash/alias" [1]="/usr/share/autojump/autojump.bash" [2]="$HOME/bin/bash/../chs/chs_completion" [3]="$HOME/bin/bash/eexp")
#for prg in ${arrays[@]}; do [ -f "$prg" ] && . $prg; done; unset prg;

