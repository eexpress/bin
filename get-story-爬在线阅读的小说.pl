#!/usr/bin/perl
# <F5>调试 //!~/bin/OLD/get-story-爬小说.pl https://www.yooread.net/3/20855/

use 5.010;
use utf8::all;	# perl-utf8-all，消除全部的 Wide character in print
#use LWP::Simple;	# perl-LWP-Protocol-https
use LWP::UserAgent;
$ua = LWP::UserAgent->new( agent => 'Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:69.0) Gecko/20100101 Firefox/69.0', timeout => 10 );

#================================
# 格式数组
# 根网址(相对于链接)，标题格式化(获取$1内容)，
# 目录掐头，目录去尾，内容掐头，内容去尾
@web=(
['www.yooread.net',		'(.*)_.*?在线阅读.*',
'直达底部','喜欢这本书的人','theme\(\);','chap_bg\(\);'],

['www.sbkk88.com',		'.*?《(.*?)》.*',
'leftList','名著分类','【回目录】','回目录】'],

['www.kanunu8.com',		'(.*?)\ -.*',
'正文','上一篇','正文','上一页'],	# 极慢

['book.tiexue.net',		'.*-(.*)txt.*',
'正文','"mRight"','"mouseRight"','上一章'],

['www.luoxia.com',		'(.*?), .*',
'章节列表','adsbygoogle','gg_post_top','上一章'],	# 卡

['www.365book.net',		'(.*?)最新章节.*',
'更新时间','友情链接','更新时间','友情链接'],	# 快
);
#================================
if(! $ARGV[0]){
	say "参数：在线阅读小说目录所在的网址。\n目前支持的网站为：";
	for (@web){say $_->[0];} exit;
}
#==============判断网址有效
$url=shift;
for($i=0;$i<@web;$i++){if($url=~m"\b$web[$i][0]\b"){say "$web[$i][0] 支持自动下载。";last;}}
if($i>=@web){say "网址不支持。";exit;}
if(grep /^$/,@{$web[$i]}){say "网址设置不完整。";exit;}
#二维数组取一维数组，需要@{}包裹
#================================
#$html=get($url);
$response = $ua->get($url);
if ($response->is_success){$html=$response->decoded_content;}
else{say "timeout!"; exit;}
say "======================";
$html=~m"<title>$web[$i][1]</title>";	# 网页标题中的书名
$name=$1; say "=====>\t《$name》";
if($name eq ""){say "书名不正确。";exit;}
$html=~s/.*$web[$i][2]//s;	# 掐头
$html=~s/$web[$i][3].*//s;	# 去尾
#say $html; exit;
open OUT,">$ENV{HOME}/$name.txt";
#================按照链接建立散列，直接sort
# 所有html链接。建立
	# 链接，章节名。
if($html=~m'href=["\']/'){				# /开头的链接
	while($html=~m'href=["\'](/.*?html*)["\'].*?>(.*?)<'g){$links{$1}=$2;}
	$url=~m'^.*//.*?/'; $prefix=$&;		#取到第一个/
}elsif($html=~m'href=["\']\d'){				# 纯数字链接
	while($html=~m'href=["\'](.*?html*)["\'].*?>(.*?)<'g){$links{$1}=$2;}
	$url=~m'.*/'; $prefix=$&;			#取到最后一个/
}elsif($html=~m'href=["\']http'){			#完整链接
	while($html=~m'href=["\'](http.*?html*)["\'].*?>(.*?)<'g){$links{$1}=$2;}
	$prefix="";
}else{
	say "没有章节链接。"; exit;
}
say "=====>\t$prefix";
#================获取各个章节
for(sort keys %links){
	$url=$_; $topic=$links{$_};
	say "=====>\t$url\t$topic";
	print OUT "\n".$topic."\n";
# 标题有‘&ldquo; &rdquo;’是中文双引号的情况。
#    next;	# 只打印章节标题
#    $_=get($prefix.$url);
	$response = $ua->get($prefix.$url);
	if ($response->is_success){$_=$response->decoded_content;}
	else{say "article timeout!"; exit;}
	s/.*$web[$i][4]//s;	# 掐头
	s/$web[$i][5].*//s;	# 去尾
#==============格式化文字内容
	s/&nbsp;/ /g; s/&quot;/"/g; s/\r//g; s/<.*?>//g; s/\n{2,}/\n/gs;
	s/-\d{1,3}-//g; s/<u>一<\/u>/\n/g; s/^\s+$//g;
	print OUT $_;
}
close OUT;
say "======================";
@_=stat("$ENV{HOME}/$name.txt"); $_=$_[7]/1000;
say "文件大小：$_ k";
#================================
##==============按照章节名，排序章节链接
#while($html=~m'href="(/.*?html*)".*?>(.*?)<'g){	# 所有html链接
#    $links{$2}=$1;	# 章节名，链接。其实可以按照链接排序。
#    push @line,$2;	# 章节名列表
#}
#@num=qw(前|序 一 二 三 四 五 六 七 八 九 十 十一 十二 十三 十四 十五 十六 十七 十八 十九 二十 二十一 二十二 二十三 二十四 二十五 尾|续);
#for (0..$#num){$hash{$num[$_]}=$_;} 	# 做一个数字索引的散列。

#@newline = sort { ($k1)=$a=~m/第(.*?)章/; ($k2)=$b=~m/第(.*?)章/; $hash{$k1}<=>$hash{$k2}; } @line;		# <=> 就是比大小并交换。

