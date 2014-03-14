#!/bin/bash

#dest='eexp@eexp-desktop.local'
dest=$(echo 'eexp@'$(avahi-browse -at|grep -v `hostname`|grep v4|awk '{print $4;}')'.local')
aptitude search '~i!~n^lib!~ndev$' | cut -b 5- | sed 's/\ .*//' >/tmp/pkg-`hostname`
ssh $dest aptitude search '~i!~n^lib!~ndev$' | cut -b 5- | sed 's/\ .*//' >/tmp/pkg-$dest
echo -e "-----------------\t\t\t--------------------"
echo -e "<`hostname`\t\t\t\t>$dest"
echo -e "-----------------\t\t\t--------------------"
diff /tmp/pkg-`hostname` /tmp/pkg-$dest | sed '/^[^<>]/d' | sed 's/^>/\t\t\t\t\t>/'
#diff /tmp/pkg-`hostname` /tmp/pkg-$dest | sed '/^[^<>]/d' | sed 's/^>/\t\t\t\t\t>/' |perl -pe 'if(/[<>]\ (.*)/){$p=`aptitude search ~i~D$1 -F %p`;if($p){$p=~s/\n/,/g;$p=~s/\s*//g;chomp;$_.="($p)\n";}}'

