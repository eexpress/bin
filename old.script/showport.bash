#!/bin/bash

#sudo netstat -antp|awk '/LISTEN/&&!/tcp6/ {split($4,p,":"); split($7,n,"/"); f=("/proc/"n[1]"/cmdline"); getline cmd<f; gsub(/\0/," ",cmd); printf ("\x1b[1;41m%s\x1b[0m\x1b[1;34m\t%10s\x1b[0m\tPID: %s\tCMD: %s\n",p[2],n[2],n[1],cmd)}'
#sudo netstat -antp|awk '/LISTEN/&&!/::/ {split($4,p,":"); split($7,n,"/"); print p[2] "\t" n[2] "\t\tPID: " n[1]}'

sudo netstat -antp|perl -n -e 'if(/LISTEN/){/:(\d+)\s/; $p=$1; /\s(\d+)\/(\w+)/; $pid=$1; $n=$2; $r=`cat /proc/$pid/cmdline`; $r=~s/\0/\ /g; printf("\x1b[1;41m%s\x1b[0m\x1b[1;34m\t%10s\x1b[0m\tPID: %s\tCMD: %s\n",$p,$n,$pid,$r);}'
