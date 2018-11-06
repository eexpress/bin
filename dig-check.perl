#!/usr/bin/perl

@dns = ("1.2.4.8","8.8.8.8","114.114.114.114","208.67.222.222 -p 443","208.67.222.222","223.5.5.5");
@dnsname = ("CNNIC云","google","114","opendns:443","opendns","阿里云");
$name=0;
foreach (@dns){
	printf "%-22s","======= $dnsname[$name] ";
	print "======>\t";
	@re = split '\n',`dig twitter.com \@$_`;
	foreach (@re){
		if (/ANSWER SECTION/../^$/){
			print "$&\t" if /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/;
		}
	} 
	$name++; print "\n";
}
