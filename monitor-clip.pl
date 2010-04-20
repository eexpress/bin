#!/usr/bin/perl

$_=`xsel -o`;
print "$_\n";
if(/http:\/\/rapidshare\.com\/files\//){
	print "add to queue file.\n";
	`echo $_ >>~/.slimrat/queue`;
	`$ENV{HOME}/bin/slimrat.bat`;
	exit;
}
if(/http:\/\/[^\s]*/){
	print "url=$&\n";
	`opera \"$&\"`;
	exit;
	}
#if(/\@(.*\.com)/){
if(/\@(.*\.(com|net|org))/){
	print "domain=$1\n";
	@l=`nslookup $1`; 
	$n=0;foreach (@l){$n++; last if /^Name/};
	$_=@l[$n];
	}
if(/\d+\.\d+\.\d+\.\d+/){
	print "ip=$&\n";
	`$ENV{HOME}/bin/ip-查询/ip-ip纯真库.pl -n $&`;
	exit;
	}
if(/pps:\/\/[^\s]*/){
	print "pps=$&\n";
	`totem \"$&\"`;
	exit;
	}
if(/^\w+$/){
	print "sdcv now\n";
	`$ENV{HOME}/bin/bot/sdcv.pl -n`;
	exit;
}
#default
#translate between en & zh_CN
`$ENV{HOME}/bin/bot/g-translate.pl -n \"$&\"`;

