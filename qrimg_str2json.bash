#!/bin/bash

if [ -z "$1" ]; then
echo "input qrcode image file or ss format string."
exit
fi

file $1|grep image
if [ $? == 0 ]; then
	configname=$1; str=`zbarimg $1`
else
	str=$1; configname="ss_string"
fi
echo $str|grep '^ss://' 1>/dev/null
if [ $? == 0 ]; then
	echo $str|grep '#' 1>/dev/null
	if [ $? == 0 ]; then configname=`echo $str|sed 's/^ss.*#//'`; fi
	str=`echo $str| sed 's-^.*//--'|sed 's/#.*$//' | base64 -d 2>/dev/null`
else
	exit
fi

#echo $str
str=`echo $str|sed 's/\(.*\)@/\1:/'` #贪婪匹配最后一个@号，换成:
arr=(${str//:/ })
echo -e "\e[1;34m---------output json------------"
cat > $configname.json << EOF
{
"remarks"	:	"${configname}",
"server"	:	"${arr[2]}",
"server_port"	:	"${arr[3]}",
"password"	:	"${arr[1]}",
"method"	:	"${arr[0]}"
}
EOF

cat $configname.json
echo -e "\e[0m"
