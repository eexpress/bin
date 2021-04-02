#!/bin/bash

cd "$HOME/app/v2ray.config/"
mkdir tmp 2>>/dev/null
for f in vv*.json; do
	str=`ss-vmess-QRcode-json.pl "$f"|grep 'vmess://'`
	vmessping_amd64_linux -c 3 "$str"
	r=$?
	echo "===> $r"
	[[ $r -eq 1 ]] && mv "$f" ./tmp/ && echo "===> mv 🐞$f🐞 to tmp"
	echo "--------------------"
done
