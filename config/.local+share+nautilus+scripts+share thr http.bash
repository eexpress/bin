#!/bin/bash

#echo $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS >>~/tmp 
#/home/eexp/桌面/选区_001.png
#echo $NAUTILUS_SCRIPT_SELECTED_URIS >>~/tmp
#file:///home/eexp/%E6%A1%8C%E9%9D%A2/%E9%80%89%E5%8C%BA_001.png
#echo $NAUTILUS_SCRIPT_CURRENT_URI >>~/tmp
#file:///home/eexp/%E6%A1%8C%E9%9D%A2
#echo $NAUTILUS_SCRIPT_WINDOW_GEOMETRY >>~/tmp
#769x848+63+24
port=8080
pkill woof
woof -c 4 -p $port $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS &
url=`ifconfig|awk '/inet /&&!/127./{print $2}'|sed 's/.*://'`
qrencode -s 5 -o /tmp/url.png "http://$url:$port"
eog /tmp/url.png && pkill woof

