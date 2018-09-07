#!/usr/bin/perl

print "$ARGV[0] ► ";
$_=`sdcv -n $ARGV[0]`; s/.*\*//s; s/相关词组.*//s; s/\n*$//s; s/\n/ ► /sg;print;
