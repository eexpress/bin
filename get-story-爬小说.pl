#!/usr/bin/perl
# <F5>调试 //!~/bin/OLD/get-story-爬小说.pl https://www.yooread.net/3/20855/

use 5.010;
use utf8::all;	# perl-utf8-all，消除全部的 Wide character in print
use LWP::Simple;	# perl-LWP-Protocol-https
#================================
# 格式数组
# 根网址(相对于链接)，标题格式化(获取$1内容)，掐头，去尾，内容范围
@aa=(
['www.yooread.net',	'(.*)_在线阅读.*',	'直达底部','喜欢这本书的人','theme\(\);(.*?)chap_bg\(\);'],
['www.sbkk88.com',	'.*?《(.*?)》.*',	'leftList','名著分类','【回目录】(.*?)【回目录】'],
);
# lwp无法get内容的网址，难道是cookie限制？
#['www.bixiadu.com',	'.*,(.*)txt.*',		'无法get?"list"','"footer"',''],
#['www.99shuku.com',	'.*,(.*)txt.*',		'无法get?','',''],
#['www.99lib.net',	'(.*)_在线阅读.*',	'无法get?','','id="content">(.*?)上一页'],
#================================
if(! $ARGV[0]){
	say "需要完整有效的网址。目前确认支持的网址为：";
	for $a (@aa){say $a->[0];}
	exit;
}
#==============判断网址有效
$url=shift;
for($i=0;$i<@aa;$i++){if($url=~m"\b$aa[$i][0]\b"){say "$aa[$i][0] 支持自动下载。";last;}}
if($i>=@aa){say "网址不支持。";exit;}
if(grep /^$/,@{$aa[$i]}){say "网址设置不完整。";exit;}
#二维数组取一维数组，需要@{}包裹
#if(!$aa[$i][2]||!$aa[$i][3]||!$aa[$i][4]){say "网址设置不完整。";exit;}
#================================
$html=get($url);
#say $html; exit;
say "======================";
$html=~m"<title>$aa[$i][1]</title>";	# 网页标题中的书名
$name=$1; say "=====>\t$name";
exit if $name eq "";
$html=~s/.*$aa[$i][2]//s;	# 掐头
$html=~s/$aa[$i][3].*//s;	# 去尾
#==============
open OUT,">$ENV{HOME}/$name.txt";
while($html=~m'href="(/.*?html*)".*?>(.*?)<'g){	# 所有html链接，暂时不好排序。
	$url="$aa[$i][0]$1"; $topic=$2;
	$url=~m"[^/]*$"; say "=====>\t$&\t$topic";	# 只打印尾部链接和标题
	print OUT "\n".$topic."\n";
	next;	# 只打印章节标题
	$txt=get("https://".$url);		# 获得每个章节
	$txt=~m"$aa[$i][5]"s; $_=$1; 
#==============格式化文字内容
	s/&nbsp;/ /g; s/&quot;/"/g; s/\r//g; s/<.*?>//g; s/\n{2,}/\n/gs;
	s/-\d{1,3}-//g; s/<u>一<\/u>/\n/g;
	print OUT $_;
}
close OUT;
say "======================";
#================================
