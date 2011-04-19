#!/usr/bin/perl

$_=`xsel -o`;
s/\s*$//;
chomp;
print "$_\n";
if(/^\// || /^~\//){
	s/^~/$ENV{HOME}/;
	if(-f){`xdg-open $_`;}
	if(-d){`rox $_`;}
	exit;
}
if(m"http://u.115.com/file/\w+"){
	`$ENV{HOME}/bin/msg elvis.png  "下载115资源" "$&"`;
	`~/bin/xterm4.pl -e ~/bin/115_down -l \'eexp,115eexp00\' $&`;
	exit;
}
if(/http:\/\/rapidshare\.com\/files\// || /hotfile\.com/ || /\.share-online\.biz/ || /megaupload.com/ || /www.fileserve.com/){
	print "add to queue file.\n";

	`$ENV{HOME}/bin/msg elvis.png  "保存并启动slimrat" "ok"`;
	`xsel -o >>~/.slimrat/url`; `echo '\n' >>~/.slimrat/url`;
	exit;
}
if(m"http://[^\s]*"){
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
#        `$ENV{HOME}/bin/ip-查询/ip-ip纯真库.pl -n $&`;
	`$ENV{HOME}/bin/ip-138查询ip属地.bash $&`;
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

