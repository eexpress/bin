#!/bin/bash

sudo netstat -antp|awk '/LISTEN/&&!/::/ {split($4,p,":"); split($7,n,"/"); f=("/proc/"n[1]"/cmdline"); getline cmd<f; gsub(/\0/," ",cmd); printf ("\x1b[1;31m%s\x1b[0m\t%10s\tPID: %s\tCMD: %s\n",p[2],n[2],n[1],cmd)}'
#sudo netstat -antp|awk '/LISTEN/&&!/::/ {split($4,p,":"); split($7,n,"/"); print p[2] "\t" n[2] "\t\tPID: " n[1]}'

