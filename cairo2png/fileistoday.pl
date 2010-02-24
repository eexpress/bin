#!/usr/bin/perl

my @t;
my $today;
my $fileday;
my $file=shift;
@t=localtime(time);
$today=($t[5]+1900)."-".($t[4]+1)."-".$t[3];
@t=localtime((stat "$file")[9]);
$fileday=($t[5]+1900)."-".($t[4]+1)."-".$t[3];
print $fileday ne $today?$fileday:"yes";

