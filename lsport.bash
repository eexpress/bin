#!/bin/bash

#greenB='\x1b[1;32m'; end='\x1b[0m'; redB='\x1b[1;31m'; blueB='\x1b[1;34m'
#my $Bred="\e[1;31m"; my $Bblue="\e[1;34m"; my $normal="\e[0m";

# 列出本机的端口
echo -e " 端口\t进程\t服务"
#sudo netstat -tpan|grep 0.0.0.0|sed 's/^[^:]*://'|sed 's/\ \+.*LISTEN\ \+/\t/g'|sed 's/\//\t/'|sort -g
#sudo netstat -tpan|perl -ne 'next if ! m"0.0.0.0"; s/^.*?://; s/\s+.*LISTEN\s+/\t/; s/\//\t/; print;'

sudo netstat -tpan|perl -lane 'next if @F[0] !~ /tcp[6]$/ | @F[5] !~ /LISTEN/; @F[3]=~s/.*://; @F[6]=~s/\//\t/; print "\e[1;34m @F[3]\e[0m\t@F[6]";'

#sudo netstat -antp|perl -n -e 'if(/LISTEN/){/:(\d+)\s/; $p=$1; /\s(\d+)\/(\w+)/; $pid=$1; $n=$2; $r=`cat /proc/$pid/cmdline`; $r=~s/\0/\ /g; printf("\x1b[1;41m%s\x1b[0m\x1b[1;34m\t%10s\x1b[0m\tPID: %s\tCMD: %s\n",$p,$n,$pid,$r);}'

