#!/usr/bin/perl

%hash=("CNNIC云"=>"1.2.4.8", "google"=>"8.8.8.8","114"=>"114.114.114.114",
"opendns:443"=>"208.67.222.222 -p 443","opendns"=>"208.67.222.222",
"阿里云"=>"223.5.5.5", "Cloudflare"=>"1.1.1.1");

$url="twitter.com"; $url=$ARGV[0] if $ARGV[0];
print "========> dig $url <========\n";
foreach $key (sort keys %hash){
	printf " %-10s\t====>\t",$key;
	@re = split '\n',`dig $url \@$hash{$key}`;
	foreach (@re){
		if (/ANSWER SECTION/../^$/){
			print "$&\t" if /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/;
		}
	} 
	print "\n";
}

