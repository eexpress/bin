#!/usr/bin/perl

$_="$ENV{HOME}/下载/pic";
mkdir "$_" if ! -f; 
chdir "$_";

use LWP::Simple;
while($url=shift){
	$pre=$url; $pre=~s/\/$//; $pre=~s/.*\///;
	print "=>\t$pre\n";
	for($i=1;$i<20;$i++){
		$page="$url/$i.html";
		print "=>\t$page\n";
		$html=get($page);
		break unless defined $html;
#获取页面中的所以图片
		while($html=~m{<img src='(.*?\.jpg)'}gsi){
		$link=$1; $pname=$link; $pname=~s/.*\///;
		print "$link\t->\t$pre-$pname\n";
		getstore($link,"$pre-$pname");
		}
	}
}

#得到页面中所有链接
#while($html=~m{<a .*?href=(["'])(.*?)\1.*?>(<.*?/>)*(.*?)</a>}gsi){
#print "$2\t--->$4\n";
#my $l=$2; my $t=$4;if($l=~/^http/ and $l!~/com\/$|cn\/$/ and $t!~/^</){print "$l\t--->$t\n";}
#}
