#!/bin/bash

if [ -z "$1" ]; then
echo "input qrcode image file or ss format string."
exit
fi

echo "========  $1 ========"
file $1|grep image
if [ $? != 0 ]; then
str=$1; fn="tmp"
else
fn=$1; str=`zbarimg $1 | sed 's/.*\/\///' | base64 -d 2>/dev/null`
fi

str=`echo $str|sed 's/\(.*\)@/\1:/'` #贪婪匹配最后一个@号
echo "---------string------------"
echo $str
arr=(${str//:/ })
lastarr=(${arr[4]//\#/ })
echo "---------array------------"
for i in ${arr[@]}; do echo $i; done
echo "---------last array------------"
for i in ${lastarr[@]}; do echo $i; done
echo "---------output json------------"
#"local_port"	:	"1080",
cat > $fn.json << EOF
{
"remarks"	:	"${lastarr[1]:-$fn}",
"server"	:	"${arr[3]}",
"server_port"	:	"${lastarr[0]}",
"password"	:	"${arr[2]}",
"method"	:	"${arr[0]}"
}
EOF

cat $fn.json
