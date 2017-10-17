#!/bin/bash

while :; do
	axel "$1"
	if [ $? -ne 0 ]; then
		canberra-gtk-play -i dialog-error
		echo "reload weapon...."
# continue download
	else
		canberra-gtk-play -i complete
		echo "finish."
		exit
	fi
done
