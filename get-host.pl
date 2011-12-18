#!/usr/bin/perl

if($ARGV[0]){@hosts=("$ARGV[0]");}
else{
@hosts=("twitter.com", "youtube.com", "blogspot.com","google.com",'plus.google.com');
}

for $h (@hosts){
$_=`w3m -dump http://pp.hawkwithwind.net/nslookup.php?server=$h&nonapi=true`;
print "# $h\n";
@_=$_=~/[0-9.]+/g;
	for (@_){
	print "$_\t$h\n";
	}
}
