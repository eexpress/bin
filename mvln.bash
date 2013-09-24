#!/bin/bash

u="mv Source Destine; ln -sf Destine Source"
[ -z "$1" ] && echo $u && exit
[ ! -f "$1" ] && echo "first argument need regular file." && exit
s=`readlink -f "$1"`

if [ -d "$2" ]; then
	d=`readlink -f "$2"`/`basename "$1"`
else
	if [ -e "$2" ]; then
		echo "second argument is exist file."
		exit
	else
		d=`dirname "$2"`
		if [ -d "$d" ]; then
			d=`readlink -f "$2"`
		else
			echo "directory $d not exists."
			exit
		fi
	fi
fi

echo "-----------------------"
echo "Source: $s"
echo "Destine: $d"
echo "-----------------------"
echo $u
echo "if confirm press [enter]. other key cancel."
read -s -n 1 y
if [[ $y == '' ]]; then
echo -e "\e[1;32mdone.\e[0m"
mv "$s" "$d"
ln -sf "$d" "$s"
ls -l --color "$s" "$d"
else
echo -e "\e[1;31mcancel.\e[0m"
fi
