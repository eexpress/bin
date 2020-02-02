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
	# 垂直，除开第一个字，字之前加间隔
	if($vmode && $index>0){$out[$index]="x"x($size/2); $index++;}
	foreach $ch (unpack("S>*",$buf)){
		$_=sprintf("%016b",$ch);
		$omit="."x(16-$size/2); s/$omit$//;	# 尾部4位丢弃
#		if($frame){$_="x".$_."x";}	# 逐字左右加边
		if($vmode){
			$out[$index]=$_;
		}else{
			if($out[$index]){$_="x".$_;}	# 水平，除开第一个字，字每行之前加间隔
			$out[$index]=$out[$index].$_;
		}
		$index+=1;
	}
}
#-------------------------------------
close IN;
$separate="x"x(length($out[0]));	# 加边框
unshift(@out, $separate);
push(@out, $separate);
for(@out){ s/(.*)/x$1x/; s/x/⚫/g; s/0/⚫/g; s/1/⚪/g; say; }
#-------------------------------------
#特殊的Unicode字符，找不到对应的字体。
#⭕ cat t|convert -pointsize 24 -font Fira-Mono-Regular label:@- t.png

