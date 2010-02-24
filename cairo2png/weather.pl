#!/usr/bin/perl

$_=`./fileistoday.pl w`;
if($ARGV[0] eq "-f"||$_ ne "yes"){
`w3m -dump http://ipiciq.com/Weather/ >w`;
}

open(REC,"w");$_=join "\n",<REC>;close REC;
s/.*?°C//s; s/•.*//s;		#去掉前后的无用信息
s/\n/ /g;
s/(%|°C)/$1\n/sg;	#规整为每天1行
s/\ +/ /g; s/\ \/\ /\//g;	# 多余的空格
s/^$//mg;
if(/网络故障/){$_="拼音或中文城市名不正确。原提示：".$_;}

s:(今日)(.*?)(\d+.*):<span color='#4746D8'>$1<span color='#E1A738'>$2</span>$3</span>:;
print;
