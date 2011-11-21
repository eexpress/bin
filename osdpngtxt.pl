#!/usr/bin/perl -w

use strict;
use Gtk2 '-init';
use Getopt::Long;
use File::MimeInfo;
use utf8;

my $png;
GetOptions('png=s'=>\$png);

my $text=join ' ',@ARGV;
$png=$png//"/usr/share/icons/infinity/48x48/places/ubuntu.png";
die "$png is not png !" if mimetype($png)!~/png/;

my $img = Cairo::ImageSurface->create_from_png ($png);
my $w=$img->get_width();
my $h=$img->get_height();

my $window = Gtk2::Window->new();
$window->set_decorated(0);
$window->add_events("GDK_BUTTON_PRESS_MASK");
#$window->add_events("GDK_MOTION_NOTIFY_MASK");
$window->set_keep_above(1);
$window->signal_connect('expose_event', \&expose);
$window->signal_connect('button_press_event',\&mouse);
$window->signal_connect('enter_notify_event',\&enter);
$window->signal_connect('leave_notify_event',\&enter);
my $screen= Gtk2::Gdk::Screen->get_default;
my $sw=$screen->get_width;
my $sh=$screen->get_height;
$window->set_colormap($window->get_screen->get_rgba_colormap());
$window->show_all();
Gtk2->main;

sub enter {
	my($widget, $event) = @_;
	my(undef, $x0,$y0,undef)=Gtk2::Gdk::Display->get_default->get_pointer;
#        my($x,$y)=$window->get_origin;

	my ($x, $y, $width, $height, $depth) = $widget->window->get_geometry;
	$window->move($x0-$width/2,$y0-$height/2);
#        print "$x0,$y0 $width x $height\n";

}
sub expose {
	my($widget, $event) = @_;
	my $cr = Gtk2::Gdk::Cairo::Context->create($widget->window);
	$cr->set_operator("source");
	$cr->set_source_surface($img,0,0);
	$cr->paint;

	$cr->select_font_face("Vera Sans YuanTi",'normal','bold');
	$cr->set_font_size($h*0.9);
	$cr->set_source_rgba(0,0,90,0.8);
	my $ww=$cr->text_extents($text.".")->{width}+$w;
	$window->set_size_request($ww, $h);
	$window->move(($window->get_screen->get_width-$ww)/2,100);
	$cr->move_to($w,$h*0.9);
	$cr->show_text($text);
	print "";
}

sub mouse{
	my ($widget, $event) = @_;
	if($event->button eq 1){
		$window->begin_move_drag($event->button,$event->x_root,$event->y_root,$event->time);
	}
	else {exit;}
}

