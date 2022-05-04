#!/bin/bash

#greenB='\x1b[1;32m'; end='\x1b[0m'; redB='\x1b[1;31m'; blueB='\x1b[1;34m'
#my $Bred="\e[1;31m"; my $Bblue="\e[1;34m"; my $normal="\e[0m";

# 列出本机的端口
echo -e " 端口\t进程\t服务"

# --tcp --listening --processes --numeric --ipv4
sudo ss -tlpn4| perl -lane 'next if ! /users/; @F[3]=~s/.*://; /"(.*)",pid=(.*),/; print "\e[1;34m @F[3]\e[0m\t$2\t$1"'

