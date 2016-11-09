#!/bin/bash

port=8080
pkill woof
file=`echo -n $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS|sed 's/\x0A//g'`
#echo "->$file<-" >> ~/tmp
woof -c 4 -p $port "$file" &
url=`ifconfig|awk '/inet /&&!/127./{print $2}'|sed 's/.*://'`
qrencode -s 5 -o /tmp/url.png "http://$url:$port"
eog /tmp/url.png && pkill woof

