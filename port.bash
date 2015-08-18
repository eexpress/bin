#!/bin/bash

sudo netstat -antp|awk '/LISTEN/&&!/::/ {split($4,p,":"); split($7,n,"/"); printf ("%s\t%10s\tPID: %s\n",p[2],n[2],n[1])}'
#sudo netstat -antp|awk '/LISTEN/&&!/::/ {split($4,p,":"); split($7,n,"/"); print p[2] "\t" n[2] "\t\tPID: " n[1]}'

