#!/usr/bin/perl

#ss://base64(method:password@server:port)#remarks
#ssr://base64(server:port:protocol:method:obfs:password/?remarks=base64(params))

use MIME::Base64;

if(! $ARGV[0]){print "input qrcode image file or ss/ssr format string.\noutput json format text.\n";exit;}

$_=$ARGV[0]; $remark="";
if(-f "$_"){
	$remark=$_; $remark=~s'.*/''g; $remark=~s'\ '_'g;
	#缺省的remark是文件名。
	$_=`zbarimg "$_"`;
}
if(! m'ssr?://'){print "no valid ss:// or ssr:// string.";exit;}

print "========================================\n";
if(/^ss:/){		#=================SS==================
	s'.*//'';	#去头
	s/#(.*)//;	#去尾。缺省贪婪匹配
	$remark=$1?$1:"new" if ! $remark;
	$_=decode_base64($_);
	s/\@/:/; @i=split ':';
	$out = <<"END";
{
"remarks"	:	"$remark",
"method"	:	"$i[0]",
"password"	:	"$i[1]",
"server"	:	"$i[2]",
"server_port"	:	"$i[3]",
"local_address"	:	"127.0.0.1",
"local_port"	:	1080
}
END
	$remark="ss-".$remark;
}
else{		#=================SSR==================
	s'.*//'';	#去头
	$_=decode_base64($_);
	s'\/\?remarks=(.*)'';	#去尾。
	@i=split ':';
	if (! $remark){
		$_=decode_base64($1);
		s'/'+'g; s' '_'g; s/\n//; s/\r//g;	#当文件名需要格式化
		$remark=$_;
	}
	$out = <<"END";
{
"remarks"	:	"$remark",
"server"	:	"$i[0]",
"server_port"	:	"$i[1]",
"protocol"	:	"$i[2]",
"method"	:	"$i[3]",
"obfs"		:	"$i[4]",
"password"	:	"$i[5]",
"local_address"	:	"127.0.0.1",
"local_port"	:	1080
}
END
	$remark="ssr-".$remark;
}
print $out;
print "========================================\n";

#输出文件
print "保存到文件？回车按键确认，其他按键取消。\n$remark.json\n";
use Term::ReadKey;
$n=5;
while ( not defined( $key = ReadKey(-1) ) ){
	$n--; print "$n."; 
	last if $n<=0;
	sleep 1;
	}
if($key eq "\n"){
	print "save.\n";
	open OUT,">$remark.json"; print OUT $out; close OUT;
	}else{print"exit.\n";}
