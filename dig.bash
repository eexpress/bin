#!/bin/bash

url="twitter.com"
url="google.com"
re='\<IN\>.*[0-9]\{1,3\}'
echo -e "===>\t SSH"
dig @128.199.153.182 $url|grep "$re"
echo -e "===>\t 114"
dig @114.114.114.114 $url|grep "$re"
echo -e "===>\t 8888"
dig @8.8.8.8 $url|grep "$re"
echo -e "===>\t hosts"
grep "\s$url" /etc/hosts
