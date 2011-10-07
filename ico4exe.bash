#!/bin/bash

f="/tmp/ico.ico"
wrestool --extract --type=group_icon "$1">$f
icotool -x $f

