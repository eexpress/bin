#!/usr/bin/perl

($sec,$min,$hour,$day,$mon,$year,$wan)=localtime(time);
$year+=1900; $mon+=1; $wan1=($wan+7-($day-1)%7)%7;	# 1号是星期几
$wan%=7;

@monarr=(0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
if ((($year % 4 == 0) && ($year % 100 != 0)) || ($year % 400 == 0)) {$monarr[2] = "29";}		# 闰年的2月

my $calendar=`calendar -A 15`;
@d=$calendar=~/月 (\d+)/g;

foreach $i (1..$monarr[$mon]){
$style=""; $under="";
if(($wan1==6)||($wan1==0)){$under="_";$style="-";}	#休息
if(grep $i==$_,@d){$style="~";}		#节日
if($i==$day){$style="+";}		#今天
$pango.=$style.$i.$under." ";
$wan1++; $wan1%=7;
}
$_=$pango;
s:-(.*?) :<span color='#E1A738'>$1</span> :g;	#休息
s:~(.*?) :<span color='#4746D8' size='larger'>$1</span> :g;	#节日
s:\+(.*?) :<span color='#C82A2A' font='45'><i>$1<span color='#44BD4A' font='25'><sub>$wan</sub></span></i></span> :g;	#今天
s:(\d+)_:<u>$1</u>:g;
$pango=$_;

#添加日期，日历，缺省颜色
@Wanday=("星期日","星期一","星期二","星期三","星期四","星期五","星期六");
my $d="$Wanday[$wan] $year 年 $mon 月 $day 日";
$pango="<span font='FZCuSong\-B09S 35'>$d</span>\n".$pango;

$calendar=~s:\d+月 \d+:<u>$&</u>:g;
$pango.="\n<span font='FZCuSong\-B09S 16'>$calendar</span>";
$pango="<span color='#957966'>".$pango."</span>";

print $pango;

