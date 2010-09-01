#!/usr/bin/perl

`$ENV{HOME}/bin/weather.pl`;
$logf="/tmp/weather";
$icondir="$ENV{HOME}/媒体/分类主题图片▲/天气/";
chdir $icondir;
open REC,$logf; @_=<REC>; close REC;
$font="~/.fonts/字体/中文字体/YuanTi/VeraSansYuanTi-Bold.ttf";
$cmd="habak ~/.fvwm/desktop.jpg -mf $font -mh 16 ";
$year="";$month="";
$x0=600;$y0=50;$w0=150;$h0=40;
@t=localtime(time);$today=($t[5]+1900)."-".($t[4]+1)."-".$t[3];
#@_=grep /$today/,@_;
$is=0; $max=4;	#从今天算起，最多显示几天。
for (@_){
next if ! /$today/ && ! $is;
$is++;
last if ($is>$max);
chomp;
($sign,$date,$weather,$temp,$wind)=split "\t",$_;
($y,$m,$d)=split "-",$date;
if($year==""){$year=$y;}elsif($year==$y){$y="";}else{$year=$y;}
if($month==""){$month=$m;}elsif($month==$m){$m="";}else{$month=$m;}
$y.="年" if($y);
$m.="月" if($m);
$d.="日";
if($sign eq ">"){$color="200,200,50,200";}elsif($sign eq "-"){$color="200,200,200,200";}else{$color="50,160,50,200";}
$y1=$y0;
$x2=$x0+2; $y2=$y1+2; $cmd.="-mc 20,20,20,200 -mp $x2,$y2 -ht $m$d ";
$cmd.="-mc $color -mp $x0,$y1 -ht $m$d ";
$y1+=$h0;
$_=$weather; $x2=$x0+20; $y2=$y1+30;
s/小雨/10-小雨.png/;s/多云/26-多云.png/;s/晴/32-晴.png/;s/转/ -mp $x2,$y2 -hi /;s/阵雨/09-阵雨.png/;
$cmd.="-mp $x0,$y1 -hi $_ ";
$y1+=3.5*$h0; 
$cmd.="-mp $x0,$y1 -ht $weather ";
$y1+=$h0; $_=$temp; s/°C/℃/g;
$x2=$x0+2; $y2=$y1+2; $cmd.="-mc 20,20,20,200 -mp $x2,$y2 -ht $_ ";
$cmd.="-mc $color -mp $x0,$y1 -ht $_ ";
$y1+=$h0;
$cmd.="-mp $x0,$y1 -ht $wind ";
$x0+=$w0;
}
print $cmd;
`$cmd`;
#---------------------------------
