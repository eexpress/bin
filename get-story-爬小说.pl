#!/usr/bin/perl

use utf8;
use LWP::Simple;
binmode STDOUT, ":utf8";	#Wide character in print
#================================
$url='https://g.sbkk88.com/mingzhu/waiguowenxuemingzhu/hali1/';
#$url='https://g.sbkk88.com/mingzhu/waiguowenxuemingzhu/hali7/';
$url=shift if $ARGV[0];	#传参数不对？有空再看。
$url=~/^.*?\..*?\//;
$root=$&; print "$root\n";
#================================
$html=get($url);
$html=~m"<title>《(.*?)》.*</title>";
$name=$1; print "$name\n";
open OUT,">$ENV{HOME}/$name.txt";
while($html=~/href="([^"]*?)">(第.{1,3}章.*?)</g){
$url="$root$1";
print "=====> $url\t$2\n";
$txt=get($url);	#获得每个章节
$txt=~m">.*(第.{1,3}章.*?).回目录"s;
$_=$1; s"&nbsp;" "g; s"<.*?>""g; s/s\(".*?"\);//g; s/^\s+$//g; s/\r//g; s/\n{2,}/\n/gs;
print OUT $_;
}
close OUT;
#================================
