#!/usr/bin/perl

use 5.010;

#解析剪贴板的数据，分成ss的参数格式。
$_=defined $ARGV[0]?$ARGV[0]:`xclip -o`;
say;say "==================";
#https://www.youneed.win/free-ss
#157.245.148.129 	17975 	isx.yt-30216959 	aes-256-cfb
@_=split /\s/;
for(@_){
	when(/^$/) {}	#网页表格鼠标选择后，夹杂空格和制表符。split导致空字符串，影响default的赋值。所以需要跳过。
	when(/\d{1,3}(\.\d{1,3}){3}/)	{$rh->{"add"}=$_}
	when(/[\w-]+(\.[\w-]+){2}/)		{$rh->{"add"}=$_}
	when(/^\d{3,5}$/)				{$rh->{"port"}=$_}
	when(/^[ac]\w+(-\w+){0,2}/)		{$rh->{"method"}=$_}
	default		{$rh->{"password"}=$_}
}
say "$rh->{method}:$rh->{password}\@$rh->{add}:$rh->{port}";
say "==================";
#exit;
if($rh->{"add"} eq ""){say "格式无效"; exit;}

# 输出成v2ray格式的json文件
$if='/home/eexpss/bin/config/proxy.config/Simple.ss.json.Template';
open IN,"<$if" or die $!; $eof=$/; undef $/; $_=<IN>; $/=$eof; close IN;
s/xxxadd/$rh->{add}/; s/xxxport/$rh->{port}/;
s/xxxmethod/$rh->{method}/; s/xxxpassword/$rh->{password}/;
$f="$ENV{HOME}/vss-$rh->{add}.json";
open OUT,">$f"; say $f;
print OUT $_; close OUT;
