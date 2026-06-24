#!/bin/bash

# adb disconnect ALL-DEVICES
# adb kill-server
# adb start-server

PHONE=192.168.3.64
PORT=$( nmap -sT ${PHONE} -p30000-49999 | awk -F/ '/tcp open/{print $1}' )
# INFO=$( nmap -sT ${PHONE} -p30000-49999 | grep '/tcp' )
# echo $INFO
# PORT=$( echo $INFO | awk -F/ '/tcp open/{print $1}' )
# PORT=$( nmap -sT ${PHONE} -p30000-49999 | awk -F/ '/tcp (open|filtered)/{print $1}' )
if [ -z $PORT ]; then echo "no wifi port."; exit; fi
# echo "====found device wifi port: "$PORT"===="

adb connect ${PHONE}:$PORT && scrcpy
