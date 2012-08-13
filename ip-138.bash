#!/bin/bash

if [ -n $1 ]; then s=$1; else s=`xsel -o`; fi
[ -z $s ] || s='?ip='$s

r=`w3m -dump -no-cookie http://www.ip138.com/ips138.asp$s|sed '0,/IP查询/d;/如果/,$d'`

echo $r
~/bin/msg "IP地址查询" "$r"
