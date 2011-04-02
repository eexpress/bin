#!/bin/bash

if [ -f "$1" ]; then
f=$1
else
echo "ls -1 *.rar *.7z|grep -F \"$1\"|head -n 1"
f=`ls -1 *.rar *.7z|grep -F "$1"|head -n 1`
fi
echo "===> $f"
e=${f##*.}
if [ $e == 'rar' ]; then e='unrar'; fi
p=`$e l $f|grep Comment|sed 's/^Comment:\s*//'`
if [ -z $p ]; then p='gahdmm.blogspot.com'; fi
echo -e "\e[1;37;41m$e x -p$p -x"*.url" \"$f\"\e[0m"
$e x -p$p "$f"
echo "\n===$e return========$?===========\n"
#[ $? -eq 0 ] && rm $1*.rar
#$e x -p$p -x"*.url" "$f"
rm *.url
