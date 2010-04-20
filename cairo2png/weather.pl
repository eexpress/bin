#!/usr/bin/perl

use File::Basename qw/basename dirname/;
use Date::Parse qw/str2time/;

chdir dirname (-l $0?readlink $0:$0);

#$_=`./fileistoday.pl w`;
#if($ARGV[0] eq "-f"||$_ ne "yes"){
if($ARGV[0] eq "-f"){
`wget http://qq.ip138.com/weather/hunan/ChangSha.wml -O w`;
}

open(REC,"w");$_=join "",grep /^<b>.*/,<REC>;close REC;
s/<br\/><br\/><b>/\n/g;
s/<br\/>/\t/g; s/<\/b>//g; s/<b>//g;
#print;
#exit;

@_=split "\n",$_;
foreach(@_){out(split "\t",$_);}

sub out{	# 输入4个参数。格式化输出。	
($day,$weather,$temp,$wind) = @_;
$~="WEATHER";
$_=`./istoday.pl $day`; 
if($_ eq "yes"){$format="color=\"#55B05A\"";}
else{
$format="size=\"small\"";
my @t=localtime str2time($day);	# 检查下星期
if(($t[6]==0)||($t[6]==6)){$day="<span color=\"#B38C45\">$day</span>";}
}
printf ("<span $format>%-10s\t%-16s\t%s</span>\n",$day,$weather,$temp);
}


