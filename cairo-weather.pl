#!/usr/bin/perl

use Encode qw(_utf8_on _utf8_off encode decode);
use Cairo;
#use Gtk2;

$rc="$ENV{HOME}/.config/cairo-weather/config";
open RC,"<$rc"; @rc=grep ! /^\s*#/ && ! /^\s*$/,<RC>; close RC;
%hrc=map{split /\s*=/} @rc;
chomp %hrc;
foreach (keys %hrc){$hrc{$_}=~s/['"]//g;}
while (my ($k,$v)=each %hrc){print "{$k}\t=> $v\n";}

`gconftool-2 -s /apps/nautilus/preferences/show_desktop false -t bool`;

until($_[3]=~/answer/){@_=`nslookup qq.ip138.com`;};
# ------以下为可自定义的部分------
#屏幕偏移坐标，可以负坐标对齐
$pos=$hrc{pos}//"-80,80";
$font=$hrc{font}//"Vera Sans YuanTi";
# 壁纸文件。
$gnomebg=`gconftool-2 -g /desktop/gnome/background/picture_filename`;
chomp $gnomebg;
$bgfile=-e $hrc{bgfile}?$hrc{bgfile}:$gnomebg;
# 城市天气信息地址
$url=$hrc{url}//"http://qq.ip138.com/weather/hunan/ChangSha.wml";
$scale=$hrc{scale}//1;
$icondir=-e $hrc{icondir}?$hrc{icondir}:"$ENV{HOME}/bin/resources/weather-icon-64";
$max=7;	#从今天算起，最多显示几天。
%indexcolor=(			# RGBA
	">"=>"#E55E23F0",	# 今天
	"-"=>"#E55E2390",	# 周日
	" "=>"#C8C8C8F0",	# 其他
	"0"=>"#14141490",	# 今天背景
	"1"=>"#14141432",	# 周日背景
);
$indexcolor{">"}=$hrc{"ctoday"} if $hrc{"ctoday"};
$indexcolor{"-"}=$hrc{"cweek"} if $hrc{"cweek"};
$indexcolor{" "}=$hrc{"cother"} if $hrc{"cother"};
$indexcolor{"0"}=$hrc{"btoday"} if $hrc{"btoday"};
$indexcolor{"1"}=$hrc{"bweek"} if $hrc{"bweek"};

# ------以上为可自定义的部分------
$outputfile="/tmp/weather.png";
@t=localtime(time);$today=($t[5]+1900)."-".($t[4]+1)."-".$t[3];
$tweek=$t[6];
@alllunar=grep {! /\d{4}/ || /2011/} `/usr/bin/calendar -A $max`;
use LWP::Simple; $_=get($url);
if($_){	#取得了网页。解析。
	$_=encode("utf8",$_);
	s/.*?(?=\d{4}-\d)//s;s/\n.*//s;	#去掉头尾无用信息。
	s/<br\/><br\/><b>/\n/g; s/<br\/>/\t/g; s/<\/b>//g; s/<b>//g;
	s/℃/°C/g; s/～/-/g; s/\x0d/\n/g;
	@_=split "\n",$_;
use Date::Parse qw/str2time/;
	for (@_){
	if (/$today/){$_=">\t$_";}
	else{	($day,@t)=split "\t";
		@t=localtime str2time($day);	# 检查下星期
		if(($t[6]==0)||($t[6]==6)){$_="-\t$_";}	#周六周日
		else {$_=" \t$_";}}
	$_.="\n";}
	} else {die "can not fetch web.\n";}
#---------------------------------
chdir $icondir;
-f "00.png" || die "can not fetch picture file.\n";
$surface = Cairo::ImageSurface->create_from_png ("00.png");
$size=$surface->get_width()*$scale;
#$size=$size*$screennw/1280;
$w0=$size*1.8;$h0=$size/3;	# 单位方框尺寸
$x0=$size/6; $y0=$size/2;
$surface = Cairo::ImageSurface->create ('argb32',$w0*$max,$size*4);
$year="";$month=""; $is=0;
#---------------------------------
for (@_){
next if ! /$today/ && ! $is;
$is++;
last if ($is>$max);
chomp;
($sign,$date,$weather,$temp,$wind)=split "\t",$_;
($y,$m,$d)=split "-",$date;
#---------------------------------
#$_=sprintf("/usr/bin/calendar -A 0 -t %04d%02d%02d",$y,$m,$d);
#@lunar=`$_`;
#$_=$lunar[0]; $_=$lunar[1] if(/\d{4}/ && ! /$y/);
@lunar=grep /$m月.*$d \t/,@alllunar;
$_=$lunar[0];
chomp;s/^.*\t//;s/\ (.*)//;$lunar[0]=$_;
#---------------------------------
if($year==""){$year=$y;}elsif($year==$y){$y="";}else{$year=$y;}
if($month==""){$month=$m;}elsif($month==$m){$m="";}else{$month=$m;}
$y.="年" if($y);
$m.="月" if($m);
$d.="日";
#---------------------------------
$color=$indexcolor{$sign};
if($sign eq ">"){drawframe($x0-$size/6,20,$indexcolor{"0"});}
if($sign eq "-"){drawframe($x0-$size/6,20,$indexcolor{"1"});}
#---------------------------------
$y1=$y0;
$fsize=$size/5;
drawtxt("$m$d - $lunar[0]",$x0,$y1);
$y1+=$h0;
$_=$weather; $x2=$x0+$size/2; $y2=$y1+$size/2;
s/小到//;s/中到//;s/大到//;s/小雨/10.png/g; s/中雨/11.png/g; s/大雨/12.png/g;s/雨夹雪/07.png/g; s/小雪/13.png/g; s/中雪/14.png/g; s/大雪/15.png/g;
s/暴雪/16.png/g;s/多云/26.png/;s/晴/32.png/;s/阴/31.png/;s/转/-/;s/雷阵雨/17.png/;s/阵雨/09.png/;
if(/-/){
my ($img1,$img2)=split "-";
$currentpng="$img1" if ! $currentpng;
#drawpng("$img1",$x0,$y1-$size/8);
drawpng("$img1",$x0,$y1);
drawpng("$img2",$x0+$size/2,$y1+$size/4);
}else{
drawpng("$_",$x0,$y1);
$currentpng="$_" if ! $currentpng;
}
$y1+=1.5*$size;
#drawpangotxt("<span color='blue'>$weather</span>",$x0,$y1);
drawtxt("$weather",$x0,$y1);
$y1+=$h0; $_=$temp; s/°C/℃/g;
drawtxt("$_",$x0,$y1);
$y1+=$h0;
$fsize=$size/6;
#_utf8_on($wind);$wind=~s/.{10}/$&\\n\\n/g;_utf8_off($wind);
($wind,$tmp)=split /\//,$wind;
drawtxt("$wind",$x0,$y1);
drawtxt("$tmp",$x0,$y1+$h0) if($tmp);
$x0+=$w0;
}
#@week=('㊐','㊀','㊁','㊂','㊃','㊄','㊅');
@week=('日','壹','貳','叁','肆','伍','陸');
$color=$indexcolor{">"};
drawstamp($week[$tweek],$size,$size*2.5);
$surface->write_to_png ("$outputfile");
#---------------------------------
#if (! $bgfile){
#● gconftool-2 -g /desktop/gnome/background/picture_filename
#        open GCONF,"<$ENV{HOME}/.gconf/desktop/gnome/background/%gconf.xml";
#        while(<GCONF>){
#                next if ! /picture_filename/;
#                $_=<GCONF>;
#                s/^.*?>//g;s/<.*$//g;chomp;
#                last;
#        }
#        close GCONF;
#        $bgfile=$_;
#        print "BG\t=>\t$_\n";
#}
#---------------------------------
#$deskpic="/tmp/weather-all.png";
#$surface = Cairo::ImageSurface->create_from_png ("/home/eexp/图片/木纹.png");
#$img = Cairo::ImageSurface->create_from_png ("$outputfile");
#$cr = Cairo::Context->create ($surface);
#($posw,$posh)=split ',',$pos; 
#print "$pos:$posw, $posh\n";
#if($posw<0){$posw=$surface->get_width()-$img->get_width()+$posw;}
#if($posh<0){$posh=$surface->get_height()-$img->get_height()+$posh;}
#$cr->set_source_surface($img,$posw,$posh);
#$cr->paint;
#$surface->write_to_png ("$deskpic");
#print "$posw, $powh. write to png. $bgfile + $outputfile = $deskpic\n";
#`gconftool-2 -s /desktop/gnome/background/picture_filename $deskpic -t string`;
#exit;
#$_=`xwininfo -root`;
#/Width:\s*\K\d+/; $screennw=$&; /Height:\s*\K\d+/; $screenh=$&;
#---------------------------------
$cmd="habak -ms \"$bgfile\" -mp $pos -hi $outputfile";
print "\e[1;37;41m$cmd\e[0m\n";
`notify-send -i "$icondir/$currentpng" "Desktop Weather with Cairo" "$cmd"`;
`$cmd`;
#---------------------------------

sub drawpng(){
my $img = Cairo::ImageSurface->create_from_png ("$_[0]");
my $cr = Cairo::Context->create ($surface);
$cr->translate($_[1],$_[2]);
$cr->scale($scale,$scale);
$cr->set_source_surface($img,0,0);
#$cr->set_source_surface($img,$_[1]/$scale,$_[2]/$scale);
$cr->paint;
}

#sub drawpangotxt(){
#my $cr = Cairo::Context->create ($surface);
#my $pango_layout = Gtk2::Pango::Cairo::create_layout ($cr);
#my $font_desc = Gtk2::Pango::FontDescription->from_string("$font $fsize");
#$pango_layout->set_font_description($font_desc);
#$pango_layout->set_markup (decode("utf-8", "$_[0]"));
#my ($R,$G,$B,$A)=split ',',$color;
#$cr->set_source_rgba(0,0,0,1);	#缺省黑色阴影
#$cr->move_to($_[1]+1,$_[2]+1);
#Gtk2::Pango::Cairo::show_layout ($cr, $pango_layout);
#$cr->show_page();
#$cr->set_source_rgba($R/256,$G/256,$B/256,$A/256);	#缺省白色字体
#$cr->move_to($_[1],$_[2]);
#Gtk2::Pango::Cairo::show_layout ($cr, $pango_layout);
#$cr->show_page();
#}

sub drawstamp()
{
my $cr = Cairo::Context->create ($surface);
#$cr->select_font_face("WenQuanYi Zen Hei",'normal','bold');
$cr->select_font_face("$font",'normal','bold');
$cr->set_font_size($fsize*5);
#my ($R,$G,$B,$A)=split ',',$color;
#$cr->set_source_rgba($R/256,$G/256,$B/256,$A/256/2);	#缺省白色字体
$color=~s/#//; my @C=map {$_/256} map {hex} $color=~/.{2}/g;
$cr->set_source_rgba($C[0]-0.3,$C[1]-0.3,$C[2]-0.3,$C[3]/1.1);
#$cr->set_operator("dest-out");
#$cr->set_operator("xor");
#$cr->set_operator("atop");
#$cr->set_operator("dest-in");
$cr->set_operator("dest-over");	#被背景覆盖
#clear, source, over, in, out, atop, dest, dest-over, dest-in, dest-out, dest-atop, xor, add, saturate
$cr->move_to($_[1],$_[2]);
$cr->rotate(-0.4);
#$cr->show_text("$_[0]");
$cr->text_path("$_[0]");
	$cr->set_line_width(2);
	$cr->set_line_join(round);	#miter, round, bevel
	$cr->set_dash((15,5,5,5),4,15);
$cr->fill_preserve();
$cr->stroke();

my $i=0;
while($i<5){
$i++;
$cr->set_source_rgba($C[0]-$i/10-0.5,$C[1]-$i/10-0.5,$C[2]-$i/10-0.5,$C[3]/1.1);
$cr->rotate(0.4);
$cr->move_to($_[1]-$i,$_[2]+$i);
$cr->rotate(-0.4);
$cr->text_path("$_[0]");
$cr->fill_preserve();
$cr->stroke();
}
}

sub drawtxt(){
my $cr = Cairo::Context->create ($surface);
$cr->select_font_face("$font",'normal','bold');
$cr->set_font_size($fsize);
$cr->set_source_rgba(0,0,0,1);	#缺省黑色阴影
$cr->move_to($_[1]+1,$_[2]+1);
$cr->show_text("$_[0]");
#my ($R,$G,$B,$A)=split ',',$color;
#$cr->set_source_rgba($R/256,$G/256,$B/256,$A/256);	#缺省白色字体
$color=~s/#//; my @C=map {$_/256} map {hex} $color=~/.{2}/g;
$cr->set_source_rgba($C[0],$C[1],$C[2],$C[3]);
$cr->move_to($_[1],$_[2]);
$cr->show_text("$_[0]");
}

sub drawframe(){
my ($x,$r,$c)=@_;
#my ($R,$G,$B,$A)=split ',',$c;
my $w=$w0;
my $h=3.5*$size;
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
$c=~s/#//; my @C=map {$_/256} map {hex} $c=~/.{2}/g;
$cr->set_source_rgba($C[0],$C[1],$C[2],$C[3]);
$cr->fill;

return if $sign eq "-";
$cr->set_line_cap(butt);	# butt, round, square
$cr->set_operator("clear");
my $l=$size/10;
$cr->set_line_width($l/2);
for ($i=0; $i<$l*2; $i++){
	$cr->move_to($x,$size+$i*$l);
	$cr->rel_curve_to($w/3,$l*2,$w*2/3,-$l*2,$w,0);
	$cr->stroke;
	}
}
