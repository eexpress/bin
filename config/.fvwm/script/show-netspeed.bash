#!/bin/bash

interval=10
prev=`cat /sys/class/net/wlan0/statistics/rx_bytes`
sleep $interval
curr=`cat /sys/class/net/wlan0/statistics/rx_bytes`

echo $curr $prev $interval|awk '{s=($1-$2)/$3/1024; if(s>=1){print s" KB/s";}else{s=s/1024; print s" MB/s";}}'
