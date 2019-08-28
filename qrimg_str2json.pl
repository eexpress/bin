#!/usr/bin/perl

#ss://base64(method:password@server:port)#remarks
#ssr://base64(server:port:protocol:method:obfs:password/?remarks=base64(params))

use 5.010;
use MIME::Base64;

if(! $ARGV[0]){say "输入二维码图像文件，或者 ss/ssr 字符串。输出 json 格式。"; exit;}

$_=$ARGV[0]; $remark="";
if(-f "$_"){
	s'.*/''g; s' '_'g; $remark=$_;		#缺省的remark是文件名。
	$_=`zbarimg "$ARGV[0]"`;
}
if(! m'ssr?://'){say "no valid ss:// or ssr:// string.";exit;}

say "========================================";
if(/^ss:/){		#=================SS==================
	s'.*//'';	#去头
	s/#(?<mark>.*)//;	#去尾。缺省贪婪匹配
#    $remark=$+{mark}?$+{mark}:"new" if ! $remark;
	$remark||=$+{mark}//="new";
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
	s'\/\?remarks=(?<mark>.*)'';	#去尾。
	@i=split ':';
	if (! $remark){
		$_=decode_base64($+{mark});
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
say $out;
say "========================================";

#输出文件
say "保存到文件 $remark.json？回车按键确认，其他按键取消。";
use Term::ReadKey;
ReadMode 4;
while ( not defined( $key = ReadKey(-1) ) ){
	state $n=8;
	$n--; print "$n."; 
	last if $n<=0;
	sleep 1;
	}
if($key eq "\n"){
	say "save.";
	open OUT,">$remark.json"; print OUT $out; close OUT;
	}else{say "exit.";}
ReadMode 0;
