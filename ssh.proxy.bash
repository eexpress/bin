#!/bin/bash

c=1
while : ; do
	ip route|grep default
	[[ $? -eq 0 ]] && break
	echo waiting net...
	((c++))
	[[ $c -gt 5 ]] && msg "ssh fault." && exit
	sleep 2
done

p=`pgrep -x -d ' ' ssh -u $(whoami)`
[[ -n $p ]] && kill $p && echo kill $p

#oneleaf
#ssh -qTfnN -D 7070 root@198.71.90.209

#imadper
#ssh -qTfnN -D 7070 root@128.199.153.182
#ssh -qTfnN -D 7070 eexp@104.236.176.123
ssh -qTfnN -D 7070 eexp@128.199.153.182

[[ $? -eq 255 ]] && msg "ssh error." || msg "ssh established."
