#!/bin/bash

# 移动文件到某处，并在原地建立一个软链接到新文件。
#~ mvln ~/.bashrc ~/bin/config/eexp.bashrc
if [[ ! -f $1 ]]; then echo "$1 not a file."; exit; fi
#~ if [[ -d $2 ]] || [[ -d $(dirname $2) && ! -f $2 && $2 != */ ]]; then
# 蛮多时候，需要覆盖目标文件。
if [[ -d $2 ]] || [[ -d $(dirname $2) && $2 != */ ]]; then
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
	echo "cd $dn0"
	cd "$dn0"
	echo "ln -sf $dn1/$fn1 $fn0"
	ln -sf "$dn1/$fn1" "$fn0"
	echo --------------------------
	\ls --color=auto -l "$dn0/$fn0"
else
	echo "dst no exist."; exit;
fi
