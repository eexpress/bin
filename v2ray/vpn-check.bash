#!/bin/bash

curl --connect-timeout 8 https://www.dnsleaktest.com/ | grep -A1 hello |  perl -pe 's/<.*?>//g; s/\t//g'
