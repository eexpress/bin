#!/bin/bash

re='\<IN\>.*[0-9]\{1,3\}'
echo SSH
dig @128.199.153.182 twitter.com|grep "$re"
echo 114
dig @114.114.114.114 twitter.com|grep "$re"
echo 8888
dig @8.8.8.8 twitter.com|grep "$re"
echo hosts
grep "\stwitter.com" /etc/hosts
