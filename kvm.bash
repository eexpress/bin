#!/bin/bash

file $1|grep partition
[ $? != 0 ] && echo 参数1不是img影像文件 && exit

if [ $2 ]; then
file $2|grep CD-ROM
[ $? != 0 ] && echo 参数2不是iso影像文件 && exit
b="-boot d -cdrom $2"
fi

kvm -smp 4 -drive file=$1,if=virtio -net nic,model=virtio -net user $b
