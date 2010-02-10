#!/usr/bin/perl

use Gtk2;	# pango need
use Cairo; 
use utf8;
use Encode;
use Getopt::Long;
$workpath="$ENV{HOME}/bin/desktop.pic/";
# 参数：单行输出选择。屏幕提示输出选择。
GetOptions('f=s'=>\$file,'w=i'=>\$w,'h=i'=>\$h,'r=i'=>\$r);
$file="pango" if ! $file; $file=$workpath.$file.".png";
$w=1200 if ! $w; $h=200 if ! $h; $r=130 if ! $r;

my $surface = Cairo::ImageSurface->create ('argb32', $w, $h); 
my $cr = Cairo::Context->create ($surface); 
#刷背景
$cr->rectangle(0,0,$w,$h);$cr->set_source_rgba(0,0,0,0.2); $cr->fill;
my $PI=3.1415926/180;
$cr->arc(0,0,$r,0,90*$PI);$cr->set_source_rgba(1,0,0,0.2); $cr->fill;
$cr->arc($r,$r,$r,180*$PI,270*$PI);$cr->set_source_rgba(0,1,0,0.2); $cr->fill;
#$cr->set_line_width(20);$cr->stroke;
#缺省字体
#my $fontname="方正粗宋简"; #my $fontname="YellowSubmarine";
my $fontname="Billo Dream";
my $pango_layout = Gtk2::Pango::Cairo::create_layout ($cr); 
my $font_desc = Gtk2::Pango::FontDescription->from_string("$fontname 22"); 
$pango_layout->set_font_description($font_desc); 
$pango_layout->set_markup (decode("utf-8", "$ARGV[0]"));
Gtk2::Pango::Cairo::show_layout ($cr, $pango_layout); 
$cr->show_page ();
$surface->write_to_png ($file);
#http://www.cairographics.org/manual/
