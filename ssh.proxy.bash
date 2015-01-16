#!/bin/bash

while : ; do
	ip route|grep default
	[[ $? ]] && break
	echo waiting net...
	sleep 2
done

#oneleaf
#ssh -qTfnN -D 7070 root@198.71.90.209

#imadper
#ssh -qTfnN -D 7070 root@128.199.153.182
#ssh -qTfnN -D 7070 eexp@104.236.176.123
ssh -qTfnN -D 7070 eexp@128.199.153.182

