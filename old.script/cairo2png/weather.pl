#!/usr/bin/perl

use File::Basename qw/basename dirname/;
use Date::Parse qw/str2time/;
use Getopt::Long;
GetOptions('conky'=>\$conky_style,'icon'=>\$use_char_icon,'force'=>\$force_update,'today'=>\$today_only);

chdir dirname (-l $0?readlink $0:$0);

@t=localtime(time);$today=($t[5]+1900)."-".($t[4]+1)."-".$t[3];
parse();

if(! /$today/||$force_update){
`wget http://qq.ip138.com/weather/hunan/ChangSha.wml -O w`;
parse();
}
#print;
#exit;

@_=split "\n",$_;
foreach(@_){out(split "\t",$_);}

sub parse{
open(REC,"w");$_=join "",grep /^<b>.*/,<REC>;close REC;
s/<br\/><br\/><b>/\n/g;
s/<br\/>/\t/g; s/<\/b>//g; s/<b>//g;
}
sub out{	# 输入4个参数。格式化输出。	
($day,$weather,$temp,$wind) = @_;
$~="WEATHER";
$_=`./istoday.pl $day`; 
if($_ eq "yes"){$format=$conky_style?"\${color1}":"color=\"#55B05A\"";}
else{
if($today_only){return;}	#只显示今天
$format=$conky_style?"":"size=\"small\"";
my @t=localtime str2time($day);	# 检查下星期
if(($t[6]==0)||($t[6]==6)){$day=$conky_style?"\${color3}$day":"<span color=\"#B38C45\">$day</span>";}
}
if ($use_char_icon){	#文字转图标字符。Weather字体
$_=$weather;
s/小雨/g/;s/多云/d/;s/晴/E/;s/转//;s/阵雨/h/;
#s/小雨/$&g/;s/多云/$&d/;s/晴/$&a/;s/转/-/;
$weather=$conky_style?"\${font Weather}$_\${font}":"<span font='Weather 40'>$_</span>";
}
if($conky_style){
printf ("$format%-10s %-12s\${alignr}%s\${color}\n",$day,$weather,$temp);
}
else{
printf ("<span $format>%-10s\t%-16s\t%s</span>\n",$day,$weather,$temp);
}
}


