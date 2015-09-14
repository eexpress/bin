#!/bin/bash

#url="twitter.com"
url="google.com"
h=${1:-$url}
#/usr/bin/dig $h |awk '/ANSWER SECTION:/,/SERVER:/'
echo ----------dig $h---------
echo -----------------------------------53----
/usr/bin/dig $h +short
if ! (nmap|grep 1053); then
echo ---------------------------------1053----
/usr/bin/dig $h -p 1053 +short
fi
echo --------------------------8.8.4.4+tcp----
/usr/bin/dig $h +tcp @8.8.4.4 +short
echo -------------------208.67.222.222+tcp----
/usr/bin/dig $h +tcp @208.67.222.222 +short

