#!/bin/bash

echo -e "端口\t进程\t服务"
sudo netstat -tpan|grep 0.0.0.0|sed 's/^[^:]*://'|sed 's/\ \+.*LISTEN\ \+/\t/g'|sed 's/\//\t/'|sort -g
