#!/bin/bash

size="4G"
file_swap=/swapfile_$size.img
if [ ! -f $file_swap ]; then
	echo "=> Create $file_swap, make as swap."
	sudo touch $file_swap
	sudo chmod 0600 $file_swap
	sudo fallocate -l $size $file_swap
	sudo mkswap $file_swap
else
	echo "=> The $file_swap exist."
fi
sudo swapon -p -2 $file_swap
[ $? -ne 0 ] && echo "=> 或者已经挂载。"
swapon
#▶ sudo swapoff /swapfile_4G.img; sudo rm /swapfile_4G.img
