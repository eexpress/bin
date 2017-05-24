#!/bin/bash

zenity --password --title="sudo"|tr -d '\n'|sudo -S dnscrypt-proxy -R cisco -a 127.0.0.2:53 -u `whoami`
#▶ g cisco /usr/share/dnscrypt-proxy/dnscrypt-resolvers.csv
#cisco,Cisco OpenDNS,Remove your DNS blind spot,Anycast,,https://www.opendns.com,1,no,no,no,208.67.220.220:443,2.dnscrypt-cert.opendns.com,B735:1140:206F:225D:3E2B:D822:D7FD:691E:A1C3:3CC8:D666:8D0C:BE04:BFAB:CA43:FB79,

