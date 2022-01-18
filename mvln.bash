#!/bin/bash

# 移动文件到某处，并在原地建立一个软链接到新文件。
#~ mvln ~/.bashrc ~/bin/config/eexp.bashrc

#~ showfile(){
	#~ var="$(script -q /dev/null ls --color=auto -l "$1"|sed '/.*:..\s/d')"
	#~ echo $var
#~ }
end='\x1b[0m'; redB='\x1b[1;31m'; blueB='\x1b[1;34m'; greenB='\x1b[1;32m';

if [[ ! -f "$1" ]]; then echo -e "STOP. $greenB$1$end ${redB}not${end} a file."; exit; fi
if [[ -h "$1" ]]; then echo -e "STOP. $greenB$1$end is a ${redB}symbolic${end} link."; exit; fi
#~ if [[ -d $2 ]] || [[ -d $(dirname $2) && ! -f $2 && $2 != */ ]]; then
# 蛮多时候，需要覆盖目标文件。
if [[ -d "$2" ]] || [[ -d $(dirname $2) && $2 != */ ]]; then
	if [[ -f "$2" ]]; then
		echo -ne 'From:\t'; \ls -l "$1"|sed 's/.*:..\s//'
		echo -ne 'To:\t'; \ls -l "$2"|sed 's/.*:..\s//'
		echo ----------------------
		echo -e "$greenB$2$end file exist, ${redB}Overwrite${end}?"
		echo "Comfirm: press SPACE/ENTER. Other keys Cancel."
		read -s -n 1 y
		if [[ $y != '' ]]; then exit; fi
	fi
	dn0=$(dirname $1)
	fn0=$(basename $1)
	dn1=$(readlink -f $2)
	if [ -d $2 ]; then
		fn1=$fn0
	else
		dn1=$(dirname $dn1)
		fn1=$(basename $2)
	fi
	echo "mv $1 $2"
	mv "$1" "$2"
	if [ "$?" -ne 0 ]; then
		echo -e "${redB}mv${end} FAILURE."
		exit
	fi
	echo "cd $dn0"
	cd "$dn0"
	echo "ln -sf $dn1/$fn1 $fn0"
	ln -sf "$dn1/$fn1" "$fn0"
	echo --------------------------
	\ls --color=auto -l "$dn0/$fn0"
else
	echo -e "Destination $greenB$2$end ${redB}not${end} exist."; exit;
fi
