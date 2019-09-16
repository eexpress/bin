#!/usr/bin/perl

use utf8::all;	# perl-utf8-all，消除全部的 Wide character in print
use LWP::Simple;	# perl-LWP-Protocol-https
#================================
$url='https://www.sbkk88.com/mingzhu/waiguowenxuemingzhu/hali7/';
$url=shift if $ARGV[0];
$url=~/^.*?\..*?\//; $root=$&;	# 获取域名部分
#================================
$html=get($url);
$html=~m"<title>.*?《(.*?)》.*</title>";	# 网页标题中的书名号
$name=$1; print "=====>\t$name\n";
#==============
open OUT,">$ENV{HOME}/$name.txt";
while($html=~/href="([^"]*?)".*?>(第.{1,5}章.*?)</g){	# 章节的链接
$url="$root$1"; $topic=$2;
$url=~m"[^/]*$"; print "=====>\t$&\t$topic\n";
print OUT $topic;
#next;
$txt=get($url);		# 获得每个章节
#$_=join "\n", grep /&nbsp;/, split /\n/, $txt;
$txt=~m"【回目录】(.*?)【回目录】"s; $_=$1; 
s/&nbsp;/ /g; s/&quot;/"/g; s/\r//g; s/<.*?>//g; s/\n{2,}/\n/gs;
s/-\d{1,3}-//g; s/<u>一<\/u>/\n/g;
print OUT $_;
}
close OUT;
#================================
