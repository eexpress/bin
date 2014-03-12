#!/bin/bash

#dest='eexp@eexp-desktop.local'
dest=$(echo 'eexp@'$(avahi-browse -at|grep -v `hostname`|grep v4|cut -d' ' -f 5)'.local')
aptitude search '~i!~n^lib' | cut -b 5- | sed 's/\ .*//' >/tmp/pkg-`hostname`
ssh $dest aptitude search '~i!~n^lib' | cut -b 5- | sed 's/\ .*//' >/tmp/pkg-$dest
echo -e "-----------------\t\t\t--------------------"
echo -e "<`hostname`\t\t\t\t>$dest"
echo -e "-----------------\t\t\t--------------------"
diff /tmp/pkg-`hostname` /tmp/pkg-$dest | sed '/^[^<>]/d' | sed 's/^>/\t\t\t\t\t>/'

