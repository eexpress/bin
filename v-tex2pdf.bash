#!/bin/bash

d=`dirname "$1"`;
echo $d;
cd "$d"

xelatex "$1"
[ $? == 0 ] && xdg-open "${1%tex}pdf"
