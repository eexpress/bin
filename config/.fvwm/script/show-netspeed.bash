#!/bin/bash

prev=`cat /sys/class/net/wlan0/statistics/rx_bytes`
for (( i = 0; i < 10 ; i ++ ))
do
	sleep 1
	curr=`cat /sys/class/net/wlan0/statistics/rx_bytes`
	echo $curr $prev|awk '{s=($1-$2)/1024; if(s>=1){print s" KB/s";}else{s=s/1024; print s" MB/s";}}'
	prev=$curr
done
