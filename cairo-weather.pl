#!/usr/bin/perl

use Encode qw(_utf8_on _utf8_off encode decode);
use Cairo;
use Gtk2;

$logf="$ENV{RES}/weather.log";
$icondir="$ENV{RES}/weather-icon-64";
$font="Vera Sans YuanTi";
$outputfile="$ENV{RES}/weather.png";
#$font="$ENV{RES}/VeraSansYuanTi-Bold.ttf";
$bgfile="$ENV{RES}/desktop.jpg";
$max=7;	#从今天算起，最多显示几天。
$align=9;
%indexcolor=(
	">"=>"200,200,200,250",	# 今天
	"-"=>"200,200,200,250",	# 周日
	" "=>"200,200,200,150",	# 其他
	"0"=>"20,20,20,180",	# 今天背景
	"1"=>"20,20,20,100",	# 周日背景
);
# ------以上为可自定义的部分------
@t=localtime((stat($logf))[9]);$fday=($t[5]+1900)."-".($t[4]+1)."-".$t[3];
@t=localtime(time);$today=($t[5]+1900)."-".($t[4]+1)."-".$t[3];
#---------------------------------
if($today ne $fday){	#不是当天的数据
until($_[0]=~/^Server:/){@_=`nslookup -timeout=2 -retry=1 www.163.com`;}
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
-f "00.png" || die "can not fetch picture file.\n";
my $size=`identify -format "%w" 00.png`;  # 以00.png的宽度定基本尺寸
chomp $size;
#---------------------------------
open REC,$logf; @_=<REC>; close REC;
$surface = Cairo::ImageSurface->create ('argb32',($size*2)*$max+20,$size*4); 
$year="";$month=""; $is=0;
$w0=$size*2;$h0=$size/2-5;	# 单位方框尺寸
@t=localtime(time);$today=($t[5]+1900)."-".($t[4]+1)."-".$t[3];
#---------------------------------
$x0=$align; $y0=$align;
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
if($sign eq ">"){drawframe($x0-$align,20,$indexcolor{"0"});}
if($sign eq "-"){drawframe($x0-$align,20,$indexcolor{"1"});}
#---------------------------------
$y1=$y0+10;
$fsize=$size/8*1.3;
drawtxt("$m$d",$x0+1,$y1+1,"20,20,20,200");
drawtxt("$m$d - $lunar[0]",$x0,$y1,$color);
$y1+=$h0;
$_=$weather; $x2=$x0+$size/2; $y2=$y1+$size/2;
s/小到//;s/中到//;s/小雨/05.png/g; s/中雨/11.png/g; s/大雨/12.png/g;s/雨夹雪/07.png/g; s/小雪/13.png/g; s/中雪/14.png/g; s/大雪/15.png/g;
s/多云/26.png/;s/晴/32.png/;s/阴/31.png/;s/转/-/;s/雷阵雨/17.png/;s/阵雨/09.png/;
if(/-/){
my ($img1,$img2)=split "-";
drawpng("$img1",$x0,$y1);
drawpng("$img2",$x0+$size/2,$y1+$size/2);
}else{
drawpng("$_",$x0,$y1);
}
$y1+=3*$h0; 
drawtxt("$weather",$x0,$y1,$color);
$y1+=$h0; $_=$temp; s/°C/℃/g;
drawtxt("$_",$x0+1,$y1+1,"20,20,20,200");
drawtxt("$_",$x0,$y1,$color);
$y1+=$h0;
$fsize=$size/8;
_utf8_on($wind);$wind=~s/.{10}/$&\n\n/g;_utf8_off($wind);
drawtxt("$wind",$x0,$y1,$color);
$x0+=$w0;
}
$surface->write_to_png ("$outputfile");
#---------------------------------
#`$ENV{HOME}/bin/conky/weather-log2txt.pl`;
`habak $bgfile -mp 360,60 -hi $outputfile`;
#---------------------------------

sub drawpng(){
my $img = Cairo::ImageSurface->create_from_png ("$_[0]"); 
my $cr = Cairo::Context->create ($surface);
$cr->set_source_surface($img,$_[1],$_[2]);
$cr->paint;
}

sub drawtxt(){
my $cr = Cairo::Context->create ($surface);
my $pango_layout = Gtk2::Pango::Cairo::create_layout ($cr); 
my $font_desc = Gtk2::Pango::FontDescription->from_string("$font $fsize"); 
$pango_layout->set_font_description($font_desc); 
$pango_layout->set_markup (decode("utf-8", "$_[0]"));
my ($R,$G,$B,$A)=split ',',$_[3];
$cr->set_source_rgba($R/256,$G/256,$B/256,$A/256);	#缺省白色字体
$cr->move_to($_[1],$_[2]);
Gtk2::Pango::Cairo::show_layout ($cr, $pango_layout); 
$cr->show_page();
}

sub drawframe(){
my ($x,$r,$c)=@_;
my ($R,$G,$B,$A)=split ',',$c;
my $w=$w0;
my $h=9*$h0;
my $cr = Cairo::Context->create ($surface);
$PI=3.1415926/180;
$cr->move_to($x+$r,0);
$cr->rel_line_to($w-2*$r,0);
$cr->rel_curve_to(0,0,$r,0,$r,$r);
$cr->rel_line_to(0,$h-2*$r);
$cr->rel_curve_to(0,0,0,$r,-$r,$r);
$cr->rel_line_to(-($w-2*$r),0);
$cr->rel_curve_to(0,0,-$r,0,-$r,-$r);
$cr->rel_line_to(0,-($h-2*$r));
$cr->rel_curve_to(0,0,0,-$r,$r,-$r);
$cr->set_source_rgba($R/256,$G/256,$B/256,$A/256); $cr->fill;
}
