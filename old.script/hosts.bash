#!/bin/bash

wget https://smarthosts.googlecode.com/svn/trunk/hosts
sudo cp hosts /etc/hosts

adb devices |grep '[0-9a-f]\{16\}'
[ $? == 1 ] && exit
echo Modify Hosts on Mobile.
adb root
adb remount
adb push hosts /system/etc/


