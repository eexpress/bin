#!/usr/bin/perl

$Bred="\e[1;31m"; $Bgreen="\e[1;32m"; $Bblue="\e[1;34m"; $normal="\e[0m"; 

if($ARGV[0]){@in=@ARGV;}else{
	$_=`xsel -o`; s/[\n'\s]//g; @in=split ','; }
foreach(@in){
	checknet($_);
}

sub checknet{
	$url=shift;
	$url.=".com" if $url !~ /\./;
#    print "$url\n"; return;

	@_=`curl --socks5 127.0.0.1:1080 "http://www.viewdns.info/chinesefirewall/?domain=$url" 2>/dev/null`;
#    push @_, 'that "is"you\'ok.'; 
	for(@_){s/'/"/g;}; `echo \'@_\' >/tmp/curl`;

	for(@_){
		s/<.*?>//g;
		print "$Bblue $1 $normal\t" if /results for ([\w\.-]*)/;
		if(/couldn't seem to find that domain/){print "$Bred ----- $normal\n";return;}
		if(/accessible/){
			if (/NOT/){print "$Bred Blocked $normal\n";return;}
			else {print "$Bgreen Pass $normal\n";return;}
		}
	}
}
