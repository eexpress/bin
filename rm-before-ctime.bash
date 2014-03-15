#!/bin/bash

#find and rm files before special time
if [[ ${#1} -eq 8 || ${#1} -eq 12 ]]; then time=$1;
elif [ ${#1} -eq 4 ]; then time=`date +%m%d`$1;
else echo "need time: [[YYYY]MMDD]hhmm"; exit; fi

#touch 不能修改ctime。只能更改系统时间后，处理。
file='/tmp/time-separate'
touch $file -t $time
if [ $? -ne 0 ]; then echo "set mtime fail"; exit; fi
now='/tmp/time-now'
touch $now
#%Y     time of last modification, seconds since Epoch
((elapse=`stat $now -c %Y`-`stat $file -c %Y`))
((min=$elapse/60))
echo $min" minutes."

#%z     time of last change, human-readable
echo "查找改动时间(ctime)在 "`stat $file -c %z`" 之前的文件。"
#%Ck    File's last status change time in the format specified by k
find . -maxdepth 1 -type f ! -cmin -$min -printf "------\t%C+\t► %p\n"

echo "----------是否删除以上文件-------------"
echo "确认执行，请按空格键/回车键。其他键取消。"
read -s -n 1 y
if [[ $y == '' ]]; then
	echo "开始删除。。。"
	find . -maxdepth 1 -type f ! -cmin -$min -exec rm {} \;
else echo "取消。"; fi

