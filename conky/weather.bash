#!/bin/bash

#[ -f "/tmp/weather" ] || ~/bin/weather.pl
~/bin/weather.pl

cat /tmp/weather|sed -e 's/°C\t.*/°C/g' -e 's/20..-//g' -e 's/^>\t/${color1}/g' -e 's/^\ \t/${color}/g' -e 's/^-\t/${color3}/g' -e 's/\t\([0-9]\)/${alignr}\1/g' -e 's///g' > /home/exp/bin/conky/weather.txt

