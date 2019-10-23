#!/usr/bin/perl

use 5.010;
use utf8::all;	# perl-utf8-all，消除全部的 Wide character in print

$ipre='\d{1,3}(\.\d{1,3}){3}';
#$ipre='\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';
#-----------------------------------
$in=$ARGV[0]//`xclip -o`;	#参数优先处理；否则处理剪贴板的大段数据。还有一种读取<>的，比如traceroute输出的，使用管道可处理，只是意义不大，直接鼠标选择traceroute大段输出来处理。
#say $in; say "----------------";
#@_=$in=~/\($ipre\)/g;	#如果使用重复3次的写法，ipre里的括号被当成分组，@_只能得到最后一个ip字段。
$in=~s/$ipre/checkip($&)/eg;	#使用/e，直接函数处理替换部分
say $in;
exit;
#-----------------------------------
sub checkip(){
	$_=shift;
	if($h->{$_}){return $_;}	#重复的ip不处理
	$h->{$_}=1;		#记录ip已经处理过
#    s/[()]//g;	#去掉前后括号
	use LWP::UserAgent;		#不使用agent，已经无法获取网站数据了。
	$ua = LWP::UserAgent->new( agent => 'Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:69.0) Gecko/20100101 Firefox/69.0', timeout => 20,);
	$response = $ua->get("http://www.ip138.com/ips138.asp?ip=".$_);
	if ($response->is_success){
		$_=$response->decoded_content;
		/本站数据：([^<]*)/;
		$_=$1; s/^\s*//; s/\s*$//;	#去掉前后空白
		return $_;
	}else{return "-----"}
}
