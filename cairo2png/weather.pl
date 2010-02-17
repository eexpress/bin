#!/usr/bin/perl

@t=localtime(time);
$today=($t[5]+1900)."-".($t[4]+1)."-".$t[3];
@t=localtime((stat "w")[9]);
$fileday=($t[5]+1900)."-".($t[4]+1)."-".$t[3];

if($fileday ne $today){
#if(! -f "w" || -M "w">0.8){
`w3m -dump http://ipiciq.com/Weather/ >w`;
}
print " $fileday\n";
open(REC,"w");$_=join "\n",<REC>;close REC;
s/.*?°C//s; s/•.*//s;		#去掉前后的无用信息
s/\n/ /g;
s/(%|°C)/$1\n/sg;	#规整为每天1行
s/\ +/ /g; s/\ \/\ /\//g;	# 多余的空格
s/^$//mg;
if(/网络故障/){$_="拼音或中文城市名不正确。原提示：".$_;}

s:(今日)(.*?)(\d+.*):<span color='#4746D8'>$1<span color='#E1A738'>$2</span>$3</span>:;
print;
