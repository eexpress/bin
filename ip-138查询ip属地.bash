#!/bin/bash

echo -e "ip="$1"&action=2"|w3m -dump -no-cookie http://www.ip138.com/ips8.asp -post -|grep '数据：'|sed 's/.*：//'
