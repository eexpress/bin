#!/usr/bin/perl
# <F5>调试 //!~/bin/OLD/get-story-爬小说.pl https://www.yooread.net/3/20855/

use 5.010;
use utf8::all;	# perl-utf8-all，消除全部的 Wide character in print
use LWP::Simple;	# perl-LWP-Protocol-https
#================================
# 格式数组
# 根网址(相对于链接)，标题格式化(获取$1内容)，掐头，去尾，内容范围
@aa=(
['www.yooread.net',	'(.*)_.*?在线阅读.*',	'直达底部','喜欢这本书的人','theme\(\);(.*?)chap_bg\(\);'],
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
open OUT,">$ENV{HOME}/$name.txt";
#==============按照章节名，排序章节链接
#while($html=~m'href="(/.*?html*)".*?>(.*?)<'g){	# 所有html链接
#    $links{$2}=$1;	# 章节名，链接。其实可以按照链接排序。
#    push @line,$2;	# 章节名列表
#}
#@num=qw(前|序 一 二 三 四 五 六 七 八 九 十 十一 十二 十三 十四 十五 十六 十七 十八 十九 二十 二十一 二十二 二十三 二十四 二十五 尾|续);
#for (0..$#num){$hash{$num[$_]}=$_;} 	# 做一个数字索引的散列。

#@newline = sort { ($k1)=$a=~m/第(.*?)章/; ($k2)=$b=~m/第(.*?)章/; $hash{$k1}<=>$hash{$k2}; } @line;		# <=> 就是比大小并交换。
#================按照链接建立散列，直接sort
# 所有html链接。建立
	# 链接，章节名。
while($html=~m'href="(/.*?html*)".*?>(.*?)<'g){$links{$1}=$2;}
#================
for(sort keys %links){
	$url=$_; $topic=$links{$_};
	say "=====>\t$url\t$topic";
#}
#for(@newline){
#    $url=$links{$_}; $topic=$_;
#    say "=====>\t$url\t$topic";
	print OUT "\n".$topic."\n";
#    next;	# 只打印章节标题
	$txt=get("https://".$aa[$i][0].$url);		# 获得每个章节
	$txt=~m"$aa[$i][4]"s; $_=$1; 
#==============格式化文字内容
	s/&nbsp;/ /g; s/&quot;/"/g; s/\r//g; s/<.*?>//g; s/\n{2,}/\n/gs;
	s/-\d{1,3}-//g; s/<u>一<\/u>/\n/g;
	print OUT $_;
}
close OUT;
say "======================";
@_=stat("$ENV{HOME}/$name.txt"); $_=$_[7]/1000;
say "文件大小：$_ k";
#================================
