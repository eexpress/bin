#!/usr/bin/perl

$_=$ARGV[0]//"localhost";
print "端口   服务       进程  命令\n";
@_=`/usr/bin/nmap $_`;
for (@_){
chomp;
s/\/tcp//;
if (/^\d+/){
@s=grep /IPv.*LISTEN/, `sudo lsof -i :$&`;
@n=split /\s+/, $s[0];
@l=split /\s+/;
$c=`cat /proc/$n[1]/cmdline`;
$c=~s/\0/\ /g;
format STDOUT=
^<<<<< ^<<<<<<<<< ^<<<<<^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$l[0],$l[2],$n[1],$c
.
write
}
}

