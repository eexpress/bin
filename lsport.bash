#!/bin/bash

# 列出本机的端口
echo -e "端口\t进程\t服务"
#sudo netstat -tpan|grep 0.0.0.0|sed 's/^[^:]*://'|sed 's/\ \+.*LISTEN\ \+/\t/g'|sed 's/\//\t/'|sort -g
sudo netstat -tpan|perl -ne 'next if ! m"0.0.0.0"; s/^.*?://; s/\s+.*LISTEN\s+/\t/; s/\//\t/; print;'

