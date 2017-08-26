#!/usr/bin/perl

use LWP::Simple;

$in=shift;
open OUT,">$in.auto.srt";
open IN,"<$in"; while(<IN>){
	if(/[a-z]{3,}/){	#带至少3个英文字母的行
		s/\<.*?\>//g; chomp;	#去掉格式
		$url="http://www.iciba.com/".$_;
		$_=get($url);
		/<h1 style=(.*?)<\/div>/s; $_=$&; #获取翻译的2行
		s'<.+?>''g; s/^\ +//m;	#去掉html格式和行首空格
		$_.="\n";
		print "==>  $_\n";
	}
	print OUT $_;
}
close IN; close OUT;
