#!/usr/bin/perl

use 5.010;
use utf8::all;
use Encode;
no warnings 'experimental::smartmatch';
#-------------------------------------
$f="HZK16"; $size=32;	# 16点阵
$f="HZK12"; $size=24;	# 12点阵

$vmode=1;	# 缺省垂直
$_=shift;
given($_){
	when('-h'){$vmode=0; $_=shift;}
	when('-v'){$vmode=1; $_=shift;}
}
$in=$_//"点阵字模";
say "-------------------------------------";
say "使用 -v -h 设置垂直或水平输出，缺省垂直输出。";
say "当前使用的点阵字库：$f";
say "-------------------------------------";
#-------------------------------------
open IN,"$f" or die $!;
binmode(IN);
$index=0;
#-------------------------------------
foreach $str (split //, $in){	# utf8::all，下句不需要decode了。
#	$str=encode( "gb2312",decode("utf8",$str));	# utf8字符转成区位码
	$str=encode( "gb2312",$str);	# utf8字符转成区位码
	($Q, $W)=unpack("C*", $str);
	$pos=(($Q-0xA0-1)*94+($W-0xA0-1))*$size;	# 偏移量
	seek(IN, $pos, 0);
	read(IN,$buf,$size);
#-------------------------------------
	if(!$vmode){$index=0;}	# 水平输出，字符串追加。
#	S				An unsigned short value.
#	> sSiIlLqQ		Force big-endian byte-order on the type.
	foreach $ch (unpack("S>*",$buf)){
		$_=sprintf("%016b",$ch);
		$omit="."x(16-$size/2); s/$omit$//;	# 尾部4位丢弃
		if($vmode){
			$out[$index]=$_;
		}else{
			$out[$index]=$out[$index]." ".$_;
		}
		$index+=1;
	}
	if($vmode){$index+=1;}	# 垂直输出，字之间隔开一行。
}
#-------------------------------------
close IN;
for(@out){ s/0/⚫/g; s/1/⚪/g; say; }
#-------------------------------------

