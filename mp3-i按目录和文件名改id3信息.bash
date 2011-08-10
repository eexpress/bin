#!/bin/bash

while [ ! -z $1 ]; do
	if [ -d $1 ];then
		#目录下所有的mp3
		p=$1
		f="*.mp3"
	else
		if ! [[ $1 =~ .mp3$ ]]; then shift; continue; fi
		p=`dirname $1`
		f=`basename $1`
	fi

	cd $p
	p=`pwd`
	d=${p##*/}
	for i in $f; do
		echo =========================
		echo -e "$i	艺术家:$d	标题:${i%.mp3}"
		mid3v2 $i -D; mid3v2 $i -a $d; mid3v2 $i -t ${i%.mp3}
	done
	shift
done
