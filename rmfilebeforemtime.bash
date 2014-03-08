#!/bin/bash

#find and rm files before special mtime

if [[ ${#1} -eq 8 || ${#1} -eq 12 ]]; then mtime=$1;
elif [ ${#1} -eq 4 ]; then mtime=`date +%m%d`$1;
else echo "need mtime: [[YYYY]MMDD]hhmm"; exit; fi

#touch 不能修改ctime。只能更改系统时间后，处理。
file='/tmp/time-separate'
touch $file -m -t $mtime
if [ $? -ne 0 ]; then echo "set mtime fail"; exit; fi
echo "查找更改时间(mtime)在 "`stat $file -c %y`" 之前的文件。"
find . -maxdepth 1 ! -cnewer $file -printf "------\t%T+\t► %p\n"

echo "----------是否删除以上文件-------------"
echo "确认执行，请按空格键/回车键。其他键取消。"
read -s -n 1 y
if [[ $y == '' ]]; then
	echo "开始删除。。。"
	find . -maxdepth 1 ! -cnewer $file -exec rm {} \;
elif
	echo "取消。"
fi

