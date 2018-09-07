#!/bin/bash

#find and rm files before special time
#新下载的，复制的文件，应该看ctime。只是节点变化了，内容mtime没变化。
if [[ ${#1} -eq 8 || ${#1} -eq 12 ]]; then time=$1;
elif [ ${#1} -eq 4 ]; then time=`date +%m%d`$1;
else echo "need time: [[YYYY]MMDD]hhmm"; exit; fi

#touch 不能修改ctime。只能更改系统时间后，处理。
file='/tmp/time-separate'
touch $file -t $time
if [ $? -ne 0 ]; then echo "set mtime fail"; exit; fi

#%y     time of last modification, human-readable
echo "查找更改时间(mtime)在 "`stat $file -c %y`" 之前的文件。"
#%Tk    File's last modification time in the format specified by k
find . -maxdepth 1 -type f ! -cnewer $file -printf "------\t%T+\t► %p\n"

echo "----------是否删除以上文件-------------"
echo "确认执行，请按空格键/回车键。其他键取消。"
read -s -n 1 y
if [[ $y == '' ]]; then
	echo "开始删除。。。"
	find . -maxdepth 1 -type f ! -cnewer $file -exec rm {} \;
else echo "取消。"; fi

