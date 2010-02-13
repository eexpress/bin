#!/usr/bin/perl

use utf8;
use Encode;
use Getopt::Long;
GetOptions('1'=>\$oneline,'n'=>\$notify);

$w=$ARGV[0]?$ARGV[0]:"长沙";
$_=`w3m -no-cookie -dump http://ipiciq.com/Weather/Default.aspx?q=$w`;
#$_=`w3m -dump http://ipiciq.com/Weather/`;
$_=decode "utf-8",$_;

s/.*?°C//s; s/•.*//s;		#去掉前后的无用信息
s/\n/ /g;
s/(%|°C)/$1\n/sg;	#规整为每天1行
s/\ +/ /g; s/\ \/\ /\//g;	# 多余的空格
s/^$//mg;
s/^/ ►/mg,s/\n//g if($oneline);
if(/网络故障/){$_="拼音或中文城市名不正确。原提示：".$_;}
print " => $w\n$_";

if($notify){
/当前：(.*?)\ /s; $str=$1;
my %pic=("晴"=>"32","阴"=>"26","雨"=>"40","雾"=>"19","雪"=>"15","云"=>"26",);
foreach (keys %pic){$str=$_,last if($str=~/$_/);}
`notify-send -u critical -i '/home/exp/媒体/图标●/png/天气/$pic{$str}.png' '$w 天气' \"$_\"`;
exit 0;
}
