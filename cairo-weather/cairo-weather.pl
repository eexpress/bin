#!/usr/bin/perl

# changelog:
# 增加 showtime 参数
# 去掉 show_app 参数
# 去掉 habak 支持
# 去掉壁纸处理

use Encode qw(_utf8_on _utf8_off encode decode);
use Cairo;
use Gtk2;
use Gnome2::GConf;
use File::Basename qw/basename dirname/;
#use POSIX qw(strftime);
#use feature qw(switch say);

$appdir="/usr/share/cairo-weather/";
if(! -e $appdir){
$appdir=dirname (-l $0?readlink $0:$0);
}
$outputfile="/tmp/weather.png";

$rcdir="$ENV{HOME}/.config/cairo-weather/";
$rc="$ENV{HOME}/.config/cairo-weather/config";
$rcsys="/usr/share/cairo-weather/config";
if (! -e $rc && -e $rcsys){`mkdir -p $rcdir; cp $rcsys $rc`;}
open RC,"<$rc"; @rc=grep ! /^\s*#/ && ! /^\s*$/,<RC>; close RC;
%hrc=map{split /\s*=/} @rc;
chomp %hrc;
foreach (keys %hrc){$hrc{$_}=~s/['"]//g;}
while (my ($k,$v)=each %hrc){print "{$k}\t=> $v\n";}
# ------以下为可自定义的部分------
#屏幕偏移坐标，可以负坐标对齐
$pos=$hrc{pos}//"-80,80";
$font=$hrc{font}//"Vera Sans YuanTi";
$showtime=$hrc{showtime}//"0";
$url=$hrc{url}//"http://qq.ip138.com/weather/hunan/ChangSha.wml";
$scale=$hrc{scale}//0.6;
$icondir=-e $hrc{icondir}?$hrc{icondir}:"$appdir/weather-icon";
%indexcolor=(			# RGBA
	"t"=>"#E55E23E0",	# 今天
	"w"=>"#E55E2390",	# 周日
	"o"=>"#C8C8C8E0",	# 其他
	"0"=>"#14141490",	# 今天背景
	"1"=>"#14141432",	# 周日背景
);
$indexcolor{"t"}=$hrc{"ctoday"} if $hrc{"ctoday"};
$indexcolor{"w"}=$hrc{"cweek"} if $hrc{"cweek"};
$indexcolor{"o"}=$hrc{"cother"} if $hrc{"cother"};
$indexcolor{"0"}=$hrc{"btoday"} if $hrc{"btoday"};
$indexcolor{"1"}=$hrc{"bweek"} if $hrc{"bweek"};

#$show_app=$hrc{show_app}//"$appdir/show_png.pl";
$refresh=$hrc{refresh}//"0";
if(! $refresh){
if ((localtime((stat($outputfile))[9]))[7] eq (localtime)[7]){
#文件是今天的
show();
exit;
}}
$_=$url;s"http://"";s"/.*"";$tmp=$_;
#until($_[1]=~/ttl/){@_=`ping -c 1 -w 10 $tmp`;}
do{@_=grep /ANSWER SECTION/,`dig $tmp`;}until(@_);
#until($_[3]=~/answer/){@_=`nslookup qq.ip138.com`;};
# ------以上为可自定义的部分------
my $city;
#@t=localtime(time);$today=($t[5]+1900)."-".($t[4]+1)."-".$t[3];
use LWP::Simple; $_=get($url);
if($_){	#取得了网页。解析。只留天气和温度，风向。
	$_=encode("utf8",$_);
if ($url=~/qq\.ip138\.com/){
	/title="(.*?)天气预报"/; $city=$1;
	s/.*?(?=\d{4}-\d)//s;s/\n.*//s;	#去掉头尾无用信息。
	s/<br\/><br\/><b>/\n/g; s/<br\/>/\t/g; s/<\/b>//g; s/<b>//g;
	s/℃/°C/g; s/～/-/g; s/\x0d/\n/g;
	s/2\d\d\d.*?\t//g;
	@_=split "\n",$_;
	}
elsif ($url=~/wap\.weather\.gov\.cn/){
	/※(.*?)\d\d/; $city=$1;
	@_=/【\d.*?<img/sg;
	for(@_){
	s/^.*nbsp;(\d)/$1/sg;
	s/[\n\r\ ]//g;s/&nbsp;//g;s/<img//g;
	s/^(.*)\t+(.*)/$2\t$1/g;
	}
	}
elsif ($url=~/m\.weather\.com\.cn/){
	s/[{},]/\n/g; s/"//g;
	%h=map{split /:/} grep /city\b|weather\d|temp\d|wind\d/,split /\n/;
	$city=$h{city};
	for $i (1..6){
	$_=$h{"weather".$i}."\t".$h{"temp".$i}."\t".$h{"wind".$i};
	push @_,$_;
	}
	}
else {die "no recognized url format.\n";}
} else {die "can not fetch web.\n";}
#        for (@_){print "$_\n";}; exit;
#---------------------------------
$max=@_;
chdir "$appdir/calendar";
`date`=~/.{4}/; $year=$&;
@alllunar=`/usr/bin/calendar -A $max -f *$year*`;
if(/12月/ ~~ @alllunar && /\ 1月/ ~~ @alllunar){
@tmp=grep /^12/,@alllunar;
$year++; $max=$max-scalar(@tmp);
@alllunar=`/usr/bin/calendar -A $max -f *$year* -t 0101`;
push @alllunar,@tmp;
}
chdir $icondir;
-f "00.png" || die "can not fetch picture file.\n";
$surface = Cairo::ImageSurface->create_from_png ("00.png");
$size=$surface->get_width()*$scale;
#$size=$size*$screennw/1280;
$w0=$size*1.8;$h0=$size/3;	# 单位方框尺寸
$x0=$size/6; $y0=$size/2;
$surface = Cairo::ImageSurface->create ('argb32',$w0*$max,$size*4);
$year="";$month=""; $cnt=0;
#---------------------------------
for (@_){
	#next if ! /$today/ && ! $is;
	@t=localtime(time+86400*$cnt);
	$sign="o"; if($cnt==0){$sign="t";$tweek=$t[6];} else{if (($t[6]==0)||($t[6]==6)){$sign="w";}}
	$cnt++;
	#last if ($cnt+1>$max);
	chomp;
	#($sign,$date,$weather,$temp,$wind)=split "\t",$_;
	($weather,$temp,$wind)=split "\t",$_;
	#($y,$m,$d)=split "-",$date;
	$y=$t[5]+1900;$m=$t[4]+1;$d=$t[3];
	#---------------------------------
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
	if($sign eq "t"){drawframe($x0-$size/6,$size/4,$indexcolor{"0"});}
	if($sign eq "w"){drawframe($x0-$size/6,$size/4,$indexcolor{"1"});}
#---------------------------------
$y1=$y0;
$fsize=$size/5;
drawtxt("$m$d - $lunar[0]",$x0,$y1);
$y1+=$h0;
$_=$weather; $x2=$x0+$size/2; $y2=$y1+$size/2;
s/小到//;s/中到//;s/大到//;
s/小雨/09.png/g; s/中雨/10.png/g; s/大雨/11.png/g;s/暴雨/12.png/g;
s/雨夹雪/07.png/g; s/小雪/13.png/g; s/中雪/14.png/g; s/大雪/15.png/g;
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
if($wind){
$y1+=$h0;
$fsize=$size/6;
#_utf8_on($wind);$wind=~s/.{10}/$&\\n\\n/g;_utf8_off($wind);
($wind,$tmp)=split /\//,$wind;
drawtxt("$wind",$x0,$y1);
drawtxt("$tmp",$x0,$y1+$h0) if($tmp);
}
$x0+=$w0;
}
#@week=('㊐','㊀','㊁','㊂','㊃','㊄','㊅');
@week=('日','壹','貳','叁','肆','伍','陸');
$color=$indexcolor{"t"};
drawstamp($week[$tweek],$size,$size*2.5,5);
drawstamp($year." ".$city, $w0*$max/2, $size*3.5,1.8,-0.2);
$surface->write_to_png ("$outputfile");
show();

#---------------------------------
sub show(){
$cmd="show_png $outputfile at $pos on desktop";
Glib::Timeout->add(1000,\&time) if $showtime;
#Glib::Timeout->add(1000,\&time);
msg(); show_png();
}
#---------------------------------
sub msg{
print "\e[1;37;41m$cmd\e[0m\n";
`notify-send -i "$icondir/$currentpng" "Desktop Weather with Cairo" "$cmd"` if -e "/usr/bin/notify-send";
}
#---------------------------------
my $img;
my $window;
my $cr;

sub show_png(){
use Gtk2 '-init';

$window = Gtk2::Window->new();
$window->set_decorated(0);
$window->add_events("GDK_BUTTON_PRESS_MASK");
#$window->add_events("GDK_SCROLL_MASK");
$window->stick;
$window->set_keep_below(1);
$window->set_skip_taskbar_hint(1);
$window->signal_connect('expose_event', \&expose);
$window->signal_connect('scroll_event',\&scroll);
$window->signal_connect('button_press_event',\&mouse);
$img = Cairo::ImageSurface->create_from_png ($outputfile);
$window->set_size_request($img->get_width(),$img->get_height());
$window->set_colormap($window->get_screen->get_rgba_colormap());

$root=Gtk2::Gdk->get_default_root_window;
my ($x, $y, $width, $height, $depth) = $root->get_geometry;
($x,$y)=split ',',$pos;
if($x<0){$x=$width+$x-$img->get_width;}
if($y<0){$y=$height+$y-$img->get_height;}

$window->move($x,$y);
$window->show_all();
Gtk2->main;
}
#---------------------------------
sub expose {
	my($widget, $event) = @_;
	$cr = Gtk2::Gdk::Cairo::Context->create($widget->window);
	$cr->set_operator("source");
	$cr->set_source_surface($img,0,0);
	$cr->paint;
	$cr->set_operator("over");
return 1 if ! $showtime;
#    $color="#007AD0a0";
	my ($sec,$min,$hour) = (localtime(time));
#    $fsize=38;
#    txt("$hour : $min",20,260);
	my @ad=qw"早上 上午 下午 晚上";
	my $pm=$ad[$hour/6];
	$hour-=12 if $hour > 12;
	my $time = sprintf "%02d : %02d",$hour,$min;
	stamp("$pm $time",140,290,3,-0.2);
	return 1;
}

sub mouse{
	my ($widget, $event) = @_;
	if($event->button eq 1){
		$window->begin_move_drag($event->button,$event->x_root,$event->y_root,$event->time);
	}
	else {exit;} #other button
}

sub scroll{
	my ($widget, $event) = @_;
	if($event->direction eq 'down'){`amixer set Master 10%-`;}
	if($event->direction eq 'up'){`amixer set Master 10%+`;}
}

sub time{
	$window->queue_draw();
	return 1;
}
#---------------------------------
sub drawpng(){
$img = Cairo::ImageSurface->create_from_png ("$_[0]");
$cr = Cairo::Context->create ($surface);
$cr->translate($_[1],$_[2]);
$cr->scale($scale,$scale);
$cr->set_source_surface($img,0,0);
#$cr->set_source_surface($img,$_[1]/$scale,$_[2]/$scale);
$cr->paint;
}

#sub drawpangotxt(){
#$cr = Cairo::Context->create ($surface);
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

sub drawstamp(){
$cr = Cairo::Context->create ($surface);
stamp(@_);
}

sub stamp(){
my $rotate=$_[4]//-0.4;
$cr->select_font_face("$font",'normal','bold');
$cr->set_font_size($fsize*$_[3]);
$color=~s/#//; my @C=map {$_/256} map {hex} $color=~/.{2}/g;
my $ebb=1.5;
$cr->set_source_rgba($C[0]/$ebb,$C[1]/$ebb,$C[2]/$ebb,$C[3]/$ebb);
$cr->set_operator("saturate");
#$cr->set_operator("dest-over");	#被背景覆盖
#clear, source, over, in, out, atop, dest, dest-over, dest-in, dest-out, dest-atop, xor, add, saturate
$cr->move_to($_[1],$_[2]);
$cr->rotate($rotate);
$cr->text_path("$_[0]");
$cr->set_line_width(3);
$cr->fill_preserve();
$cr->stroke();

for $i (1..$_[3]){
$i++;
$cr->set_source_rgba($C[0]-$i/3,$C[1]-$i/3,$C[2]-$i/3,$C[3]/1.2);
$cr->rotate(-$rotate);
$cr->move_to($_[1]-$i,$_[2]+$i);
$cr->rotate($rotate);
$cr->text_path("$_[0]");
$cr->fill_preserve();
$cr->stroke();
}
}

sub drawtxt(){
$cr = Cairo::Context->create ($surface);
txt(@_);
}

sub txt(){
$cr->select_font_face("$font",'normal','bold');
$cr->set_font_size($fsize);
$cr->set_source_rgba(0,0,0,1);	#缺省黑色阴影
$cr->move_to($_[1]+1,$_[2]+1);
$cr->show_text("$_[0]");
$color=~s/#//; my @C=map {$_/256} map {hex} $color=~/.{2}/g;
$cr->set_source_rgba($C[0],$C[1],$C[2],$C[3]);
$cr->move_to($_[1],$_[2]);
$cr->show_text("$_[0]");
}

sub drawframe(){
my ($x,$r,$c)=@_;
my $w=$w0;
my $h=3.5*$size;
$cr = Cairo::Context->create ($surface);
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

#return if $sign eq "w";
$cr->set_line_cap("butt");	# butt, round, square
$cr->set_line_join("round");	# miter, round, bevel
$cr->set_operator("clear");
my $l=$size/10;
$cr->set_line_width($l/2);
for $i (0..$l*1.5){
	$cr->move_to($x,$size+$i*$l);
	if($sign eq "t"){
	$cr->rel_curve_to($w/3,$l*2,$w*2/3,-$l*2,$w,0);
	}else{
	for $d (1,-1,1,-1){$cr->rel_line_to($w/4,$d*$h/20);}
	}
	$cr->stroke;
	}
}
