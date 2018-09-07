#!/usr/bin/perl

my $ppp='\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';
die "无效ipv4格式" if $ARGV[0]!~/^$ppp$/;

print $ARGV[0];
open(who, "whois -h whois.apnic.net $ARGV[0]|");
my $l;
while(<who>){
	chomp;
	s/$&:\s*//,print " ► $_" if /^descr|^address|^country/;
	print " ▇ " if /^source/;
	last if /^person/;
}
close(who);
