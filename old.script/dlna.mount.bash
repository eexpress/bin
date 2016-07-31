#!/bin/bash

cd
if [ ! -d upnp ]; then
	mkdir upnp; chmod 777 upnp
	sudo modprobe fuse
	sudo djmount -o allow_other upnp/
	xdg-open upnp
else
	sudo fusermount -u upnp
	rmdir upnp
	echo umount upnp and rmdir
fi

