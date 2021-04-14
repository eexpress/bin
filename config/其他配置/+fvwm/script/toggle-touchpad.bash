#!/bin/bash

n=`xinput -list --name-only | grep TouchPad`
echo $n
xinput list-props "$n"|grep "Device Enabled"|grep "1$" > /dev/null && xinput disable "$n" || xinput enable "$n"
xinput list-props "$n"|grep "Device Enabled"
