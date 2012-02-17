#!/usr/bin/perl

# only 8 bytes
print "$ARGV[0]:".crypt($ARGV[1],$ARGV[1])."\n";
