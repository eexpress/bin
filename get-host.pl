#!/usr/bin/perl

if($ARGV[0]){@hosts=("$ARGV[0]");}
else{
@hosts=("twitter.com", "youtube.com", "blogspot.com","google.com",'plus.google.com');
}

$server='8.8.8.8';
for $h (@hosts){
$_=`nslookup $h $server`;
print "# $h\n";
@_=$_=~/[0-9.]{7,}+/g;
	for (@_){
	print "$_\t$h\n" if ! /$server/;
	}
}
