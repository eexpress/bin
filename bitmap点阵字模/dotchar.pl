#!/usr/bin/perl

use 5.010;
use utf8::all;
use Encode;
#-------------------------------------
$f="HZK16"; $size=32;	# 16点阵
$f="HZK12"; $size=24;	# 12点阵
open IN,"$f" or die $!;
binmode(IN);
say "-------------------------------------";
say "当前使用的点阵字库：$f";
say "-------------------------------------";
#-------------------------------------
$in=$ARGV[0]//"点阵字模";
foreach $str (split //, $in){	# utf8::all，下句不需要decode了。
#	$str=encode( "gb2312",decode("utf8",$str));	# utf8字符转成区位码
	$str=encode( "gb2312",$str);	# utf8字符转成区位码
	($Q, $W)=unpack("C*", $str);
	$pos=(($Q-0xA0-1)*94+($W-0xA0-1))*$size;	# 偏移量
	seek(IN, $pos, 0);
	read(IN,$buf,$size);
#-------------------------------------
#	S				An unsigned short value.
#	> sSiIlLqQ		Force big-endian byte-order on the type.
	foreach $ch (unpack("S>*",$buf)){
		$_=sprintf("%016b",$ch);
		s/0/ /g; s/1/⏺/g;
		say;
	}
	say "";
}
close IN;

