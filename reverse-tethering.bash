#!/bin/bash

adb root
adb shell busybox ifconfig
adb shell netcfg rndis0 dhcp
adb shell ifconfig rndis0 10.42.0.2 netmask 255.255.255.0
adb shell route add default gw 10.42.0.1 dev rndis0
