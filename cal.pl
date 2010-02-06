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
my $d="$Wanday[$wan] $year 年 $mon 月 $day 日";
$pango="<span font='FZCuSong\-B09S 40'>$d</span>\n";

my $calendar=`calendar -A 15`;
$calendar=decode "utf-8",$calendar;
@d=$calendar=~/月 (\d+)/g;

foreach $i (1..$monarr[$mon]){
$pre=""; $end="";
if(($wan1==6)||($wan1==0)){$pre="-";}
#if(grep /$i/,@d){}
foreach (@d){if($i==$_){$pre="~";}}
if($i==$day){$pre="_";$end=".".$wan;}
$pango.=$pre.$i.$end." ";
$wan1++; $wan1%=7;
}
$_=$pango;
s:-(\d+):<span color='#E1A738'><u>$1</u></span>:g;	#休息
s:~(\d+):<span color='#4746D8' size='larger'>$1</span>:g;	#节日
s:_(\d+).(\d+):<span color='#C82A2A' font='45'><i>$1<sub>$1</sub></i></span>:g;	#今天
$pango=$_;

$pango.="\n<span font='FZCuSong\-B09S 16'>$calendar</span>";
$pango="<span color='#957966'>".$pango."</span>";
print $pango;

if($notify){`gnome-osd-client "$pango"`;}
else{`$ENV{HOME}/bin/pango2png.pl "$pango" -f cal`;}

#http://library.gnome.org/devel/pango/stable/PangoMarkupFormat.html
