#!/usr/bin/perl -w

use strict;
use Gtk2 '-init';
use Cairo;

my $text=$ARGV[0]//'OSD 演示';
my $size=20;

my $extent;
my $screen=Gtk2::Gdk::Screen->get_default;
my $window = Gtk2::Window->new();
$window->set_decorated(0);
$window->add_events("GDK_BUTTON_PRESS_MASK");
$window->set_keep_above(1);
$window->signal_connect('expose_event', \&expose);
$window->signal_connect('button_press_event',\&mouse);
my $w=$screen->get_width;
my $h=$screen->get_height;
print "screen : $w - $h\n";
$window->set_size_request($w,$h);
$window->move(0,0);
my $img=Cairo::ImageSurface->create ('argb32',1,1);

Glib::Timeout->add(10,\&time);
$window->set_colormap($window->get_screen->get_rgba_colormap());
$window->show_all();
Gtk2->main;

sub expose {
	my($widget, $event) = @_;
	my $cr = Gtk2::Gdk::Cairo::Context->create($widget->window);
	$cr->set_operator('source');
	$cr->set_source_surface($img,0,0);
	$cr->paint;

	$cr->select_font_face("Vera Sans YuanTi",'normal','bold');
	$cr->set_font_size($size);
	my $alpha=2*$size/$h; if($alpha>0.7){$alpha=0.7;}
	$cr->set_source_rgba(0,0,90,$alpha);
	$cr->move_to(0,$h-$size/2);
	$extent=$cr->text_extents($text.".");
	$cr->show_text($text);
	# 奇怪的print。不写就不画上面的文字。第一次碰到这情况。
	print "";
}

sub mouse{
	my ($widget, $event) = @_;
	if($event->button eq 1){
		$window->begin_move_drag($event->button,$event->x_root,$event->y_root,$event->time);
	}
	else {exit;}
}

sub time{
	$size+=20;
	if($size*1.5>$h){return 0;}
	if($extent->{width}>$w){return 0;}
	$window->queue_draw() ;
	return 1;
}
