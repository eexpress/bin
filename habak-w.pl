#!/usr/bin/perl

use Encode qw(_utf8_on _utf8_off encode);

$logf="$ENV{HOME}/bin/resources/weather.log";
$x0=420;$y0=80;			# 屏幕起始坐标
$icondir="$ENV{HOME}/bin/resources/weather-icon-64";
$font="$ENV{HOME}/bin/resources/VeraSansYuanTi-Bold.ttf";
$bgfile="$ENV{HOME}/bin/resources/desktop.jpg";
$max=7;	#从今天算起，最多显示几天。
%indexcolor=(
	">"=>"200,200,200,250",	# 今天
	"-"=>"200,200,200,250",	# 周日
	" "=>"200,200,200,150",	# 其他
);
# ------以上为可自定义的部分------
#`$ENV{HOME}/bin/weather.pl`;
@t=localtime((stat($logf))[9]);$fday=($t[5]+1900)."-".($t[4]+1)."-".$t[3];
@t=localtime(time);$today=($t[5]+1900)."-".($t[4]+1)."-".$t[3];
#---------------------------------
if($today ne $fday){	#不是当天的数据
until($_[0]=~/^Server:/){@_=`nslookup -timeout=1 -retry=1 www.163.com`;}
use LWP::Simple; $_=get("http://qq.ip138.com/weather/hunan/ChangSha.wml");
if($_){	#取得了网页。解析。
	$_=encode("utf8",$_);
	s/.*?(?=\d{4}-\d)//s;s/\n.*//s;	#去掉头尾无用信息。
	s/<br\/><br\/><b>/\n/g; s/<br\/>/\t/g; s/<\/b>//g; s/<b>//g;
	s/℃/°C/g; s/～/-/g; s/\x0d/\n/g;
	@_=split "\n",$_;
#---------------------------------
	use Date::Parse qw/str2time/;
	open REC,">$logf"; for (@_){
	if (/$today/){$_=">\t$_";}
	else{	($day,@t)=split "\t";
		@t=localtime str2time($day);	# 检查下星期
		if(($t[6]==0)||($t[6]==6)){$_="-\t$_";}	#周六周日
		else {$_=" \t$_";}}
	$_.="\n"; print REC; 
	}; close REC; }}
#---------------------------------
-f $logf || die "can not fetch log file.\n";
chdir $icondir;
my $size=`identify -format "%w" 00.png`;  # 以00.png的宽度定基本尺寸
my $bgs=($size*2)."x".($size*4);
`convert -size $bgs xc:\'#ffffff20\' bg-w.png` if (! -f "bg-w.png");
`convert -size $bgs xc:\'#ffffff30\' bg.png` if (! -f "bg.png");
#---------------------------------
open REC,$logf; @_=<REC>; close REC;
$cmd="habak $bgfile -mf $font ";
$year="";$month=""; $is=0;
$w0=$size*2;$h0=$size/2;	# 单位方框尺寸
@t=localtime(time);$today=($t[5]+1900)."-".($t[4]+1)."-".$t[3];
#---------------------------------
for (@_){
next if ! /$today/ && ! $is;
$is++;
last if ($is>$max);
chomp;
($sign,$date,$weather,$temp,$wind)=split "\t",$_;
($y,$m,$d)=split "-",$date;
#---------------------------------
$_=sprintf("/usr/bin/calendar -A 0 -t %04d%02d%02d",$y,$m,$d);
@lunar=`$_`;
$_=$lunar[0]; $_=$lunar[1] if(/\d{4}/ && ! /$y/);
chomp;s/^.*\t//;s/\ (.*)//;$lunar[0]=$_;
#---------------------------------
if($year==""){$year=$y;}elsif($year==$y){$y="";}else{$year=$y;}
if($month==""){$month=$m;}elsif($month==$m){$m="";}else{$month=$m;}
$y.="年" if($y);
$m.="月" if($m);
$d.="日";
#---------------------------------
$color=$indexcolor{$sign};
if($sign eq ">"){my $ybg=$y0-$size/4*1.4; my $xbg=$x0-$size/4+2;$cmd.="-mp $xbg,$ybg -hi bg.png ";}
if($sign eq "-"){my $ybg=$y0-$size/4*1.4; my $xbg=$x0-$size/4+2;$cmd.="-mp $xbg,$ybg -hi bg-w.png ";}
#---------------------------------
$y1=$y0;
$fsize=$size/8*1.3;
$x2=$x0+2; $y2=$y1+2; $cmd.="-mh $fsize -mc 20,20,20,200 -mp $x2,$y2 -ht $m$d ";
$cmd.="-mc $color -mp $x0,$y1 -ht \"$m$d - $lunar[0]\" ";
$y1+=$h0;
$_=$weather; $x2=$x0+$size/2; $y2=$y1+$size/2;
s/小到//;s/小雨/10.png/g; s/中雨/11.png/g; s/大雨/12.png/g;
s/多云/26.png/;s/晴/32.png/;s/阴/31.png/;s/转/ -mp $x2,$y2 -hi /;s/雷阵雨/17.png/;s/阵雨/09.png/;
$cmd.="-mp $x0,$y1 -hi $_ ";
$y1+=3*$h0; 
$cmd.="-mp $x0,$y1 -ht $weather ";
$y1+=$h0; $_=$temp; s/°C/℃/g;
$x2=$x0+2; $y2=$y1+2; $cmd.="-mc 20,20,20,200 -mp $x2,$y2 -ht $_ ";
$cmd.="-mc $color -mp $x0,$y1 -ht $_ ";
$y1+=$h0;
$fsize=$size/8;
_utf8_on($wind);$wind=~s/.{10}/$&\n\n/g;_utf8_off($wind);
$cmd.="-mp $x0,$y1 -mh $fsize -ht \"$wind\" ";
$x0+=$w0;
}
print $cmd;
`$cmd`;
#---------------------------------
