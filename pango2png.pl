#!/usr/bin/perl -w

use strict; 
use Gtk2; 
use Cairo; 
use utf8;
use Encode;

my $surface = Cairo::ImageSurface->create ('argb32', 1280, 300); 
my $cr = Cairo::Context->create ($surface); 

#$cr->rectangle (0, 0, 1280, 300); 
#$cr->set_source_rgb (1, 1, 1); 
#$cr->fill; 

my $pango_layout = Gtk2::Pango::Cairo::create_layout ($cr); 

#缺省字体
#my $fontname="经典繁颜体";
#my $fontname="方正粗宋简";
#my $fontname="YellowSubmarine";
my $fontname="Billo Dream";
#my $fontname=`xsel -o`;

my $font_desc = Gtk2::Pango::FontDescription->from_string("$fontname 22"); 
$pango_layout->set_font_description($font_desc); 
#$pango_layout->set_font_description("$fontname 22"); 

#$pango_layout->set_markup ("$ARGV[0]");
$pango_layout->set_markup (decode("utf-8", "$ARGV[0]"));
#$cr->set_source_rgb (0, 0, 0); 
Gtk2::Pango::Cairo::show_layout ($cr, $pango_layout); 
$cr->show_page (); 
$surface->write_to_png ('/tmp/pango.png');

