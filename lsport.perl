#!/usr/bin/perl

$_=$ARGV[0]//"localhost";
print "端口\t\t状态\t服务\t服务名\t   端口名\n";
@_=`/usr/bin/nmap $_`;
for (@_){
chomp;
if (/^\d+/){
@s=grep /IPv.*LISTEN/, `sudo lsof -i :$&`;
@n=split /\s+/, $s[0];
@l=split /\s+/, "$_\t$n[0]\t$n[8]\n";
format STDOUT=
^<<<<<<<<<<<<<<<^<<<<<<<^<<<<<<<^<<<<<<<<<<^<<<<<<<<<<<<<<<<<
$l[0],$l[1],$l[2],$l[3],$l[4]
.
write
}
}

