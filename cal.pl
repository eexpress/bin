#!/usr/bin/perl

use utf8;
use Getopt::Long;
use Encode;

# 参数：单行输出选择。屏幕提示输出选择。
GetOptions('n' => \$notify);

($sec,$min,$hour,$day,$mon,$year,$wan)=localtime(time);
$year+=1900; $mon+=1; $wan1=($wan+7-($day-1)%7)%7;	# 1号是星期几

@monarr=(0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
if ((($year % 4 == 0) && ($year % 100 != 0)) || ($year % 400 == 0)) {$monarr[2] = "29";}		# 闰年的2月

@Wanday=("星期日","星期一","星期二","星期三","星期四","星期五","星期六");
#my $d=decode("utf-8","$Wanday[$wan] $year 年 $mon 月 $day 日");
my $d="$Wanday[$wan] $year 年 $mon 月 $day 日";
$pango="<span color='#957966' font='FZCuSong\-B09S 40'>$d</span>\n";
foreach $i (1..$monarr[$mon]){
if(($wan1==6)||($wan1==0)){
$fcolor="<span color='#E1A738'><u>";$ecolor="</u></span>";}
#underline_color='red'
else {$fcolor="<span color='#957966'>";$ecolor="</span>";}
if($i==$day){$fcolor="<span color='#C82A2A' font='45'><i>";$ecolor="</i></span><span color='#C82A2A'><sub><i>$wan</i></sub></span>";}
$pango.="$fcolor$i$ecolor ";
$wan1++; $wan1%=7;
}
#$pango.="<span color='red' font='40'>$hour:$min</span>";
#my $calendar=decode("utf-8",`calendar -A 15`);
my $calendar=`calendar -A 15`;
$calendar=decode "utf-8",$calendar;
$pango.="\n<span color='#957966' font='FZCuSong\-B09S 16'>$calendar</span>";
print $pango;

if($notify){`gnome-osd-client "$pango"`;}
else{`$ENV{HOME}/bin/pango2png.pl "$pango"`;}

#@Month =("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");
#$date=sprintf("%04d年%02d月",$year,$mon);
#use POSIX qw(strftime);
#my $d=strftime("%A %Y年 %m月 %d日",localtime(time));
#http://library.gnome.org/devel/pango/stable/PangoMarkupFormat.html
