#!/bin/bash

PHONE=192.168.3.64
adb connect ${PHONE}:$( nmap -sT ${PHONE} -p30000-49999 | awk -F/ '/tcp open/{print $1}' )

scrcpy
