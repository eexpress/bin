#!/usr/bin/perl

($sec,$min,$hour,$day,$mon,$year,$wan)=localtime(time);
$year+=1900; $mon+=1; $wan1=($wan+7-($day-1)%7)%7;	# 1号是星期几

@monarr=(0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
if ((($year % 4 == 0) && ($year % 100 != 0)) || ($year % 400 == 0)) {$monarr[2] = "29";}		# 闰年的2月

$pango="<span color='blue' font='36'>$year-$mon </span>";
foreach $i (1..$monarr[$mon]){
if(($wan1==6)||($wan1==0)){
$fcolor="<span color='blue' font='22'><u>";$ecolor="</u></span>";}
#underline_color='red'
else {$fcolor="";$ecolor="";}
if($i==$day){$fcolor="<span color='red' font='40'><i>";$ecolor="</i></span>";}
$pango.="$fcolor$i$ecolor ";
$wan1++; $wan1%=7;
}
$pango.="<span color='red' font='40'>$hour:$min</span>";
print $pango;
`gnome-osd-client "$pango"`;

#@Wanday=("星期日","星期一","星期二","星期三","星期四","星期五","星期六");
#@Month =("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");
#$date=sprintf("%04d年%02d月",$year,$mon);
#http://library.gnome.org/devel/pango/stable/PangoMarkupFormat.html
