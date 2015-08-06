#!/bin/bash

#▶ for i in *.png; do echo -e "\n===== $i"; zbarimg $i | sed 's/.*\/\///' | base64 -d; done
#▶ for i in *.png; do ./qrcode2ss.json.bash $i; done

echo "========  $1 ========"
str=`zbarimg $1 | sed 's/.*\/\///' | base64 -d 2>/dev/null`
echo $str
#密码使用：@会导致无法识别
arr=(${str//:/ })
str=${arr[1]}
arr1=(${str//@/ })
echo "---------------------"
for i in ${arr[@]}; do echo $i; done  
for i in ${arr1[@]}; do echo $i; done  

[ -z ${arr[3]} ] && lp=1080 || lp=${arr[3]}

cat > $1.json << EOF
{
"remarks"		:	"$1",
"server"		:	"${arr1[1]}",
"server_port"	:	${arr[2]},
"local_port"	:	$lp,
"password"		:	"${arr1[0]}",
"method"		:	"${arr[0]}"
}
EOF
