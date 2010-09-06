#!/usr/bin/perl

`$ENV{HOME}/bin/weather.pl`;
$logf="/tmp/weather";
$icondir="$ENV{HOME}/媒体/分类主题图片▲/天气/";
chdir $icondir;
open REC,$logf; @_=<REC>; close REC;
$font="~/.fonts/字体/中文字体/YuanTi/VeraSansYuanTi-Bold.ttf";
$cmd="habak ~/.fvwm/desktop.jpg -mf $font -mh 16 ";
$year="";$month="";
$x0=500;$y0=50;$w0=200;$h0=35;
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
%indexcolor=(
	">"=>"200,200,50,180",
	" "=>"200,200,200,100",
	"-"=>"50,160,50,150",
);
$color=$indexcolor{$sign};
#if($sign eq ">"){$color="200,200,50,200";}elsif($sign eq "-"){$color="200,200,200,200";}else{$color="50,160,50,200";}
$y1=$y0;
$x2=$x0+2; $y2=$y1+2; $cmd.="-mc 20,20,20,200 -mp $x2,$y2 -ht $m$d ";
$cmd.="-mc $color -mp $x0,$y1 -ht $m$d ";
$y1+=$h0;
$_=$weather; $x2=$x0+30; $y2=$y1+50;
#@arr=(
#["小到",""],["小雨","10.png"],["中雨","11.png"],["大雨","12.png"],
#["多云","26.png"],["晴","32.png"],["阴","31.png"],
#["转"," -mp $x2,$y2 -hi "],
#["雷阵雨","17.png"],["阵雨","09.png"]
#);
#for $cw (0..$#arr){s/$arr[$cw][0]/$arr[$cw][1]/;}
s/小到//;s/小雨/10.png/; s/中雨/11.png/; s/大雨/12.png/;
s/多云/26.png/;s/晴/32.png/;s/阴/31.png/;s/转/ -mp $x2,$y2 -hi /;s/雷阵雨/17.png/;s/阵雨/09.png/;
$cmd.="-mp $x0,$y1 -hi $_ ";
$y1+=5*$h0; 
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
