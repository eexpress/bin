#!/usr/bin/perl

$_=`xsel -o`;
s/\s*$//;
chomp;
print "$_\n";
if(/^\//){
	if(-f){`xdg-open $_`;}
	if(-d){`rox $_`;}
	exit;
}
if(/http:\/\/rapidshare\.com\/files\// || /hotfile\.com/ || /\.share-online\.biz/){
	print "add to queue file.\n";

	`$ENV{HOME}/bin/msg elvis.png  "保存并启动slimrat" "ok"`;
	`xsel -o >>~/.slimrat/queue`; `echo '\n' >>~/.slimrat/queue`;
#        `echo $_ >>~/.slimrat/queue`;
#        `$ENV{HOME}/bin/slimrat.bat`;
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

