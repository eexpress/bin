#!/bin/bash

#$1是最终目录和文件名。$2有，就是同时选换成avi。
d="~/下载/$1"
mkdir $d
find ~/.opera/cache*/ -size +1500k -exec mv {} $d/ \;
cd $d

if [ -z "$2" ]; then
	rename 's/$/.mp4/' *
	echo "---------------"; ls
else
#find ~/.opera/cache*/ -cmin -60 -size +1500k -printf "------\t%p\t► %Ac\t► %kK\v\r" -exec mv {} . \;
	/usr/bin/mencoder  -ovc lavc -lavcopts vcodec=mpeg4 -oac mp3lame opr* -o "$1.avi"
	rm opr*
	msg "转换avi完成"
fi

