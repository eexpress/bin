#!/usr/bin/perl -w

use strict;
use Gtk2 '-init';

my $file=$ARGV[0]//'/tmp/weather.png';
die "no pic" if ! -e $file;
my $window = Gtk2::Window->new();
$window->set_decorated(0);
$window->add_events("GDK_BUTTON_PRESS_MASK");
$window->stick;
$window->set_keep_below(1);
#$window->set_keep_above(1);
$window->signal_connect('expose_event', \&expose);
$window->signal_connect('button_press_event',\&mouse);
my $img = Cairo::ImageSurface->create_from_png ($file);
$window->set_size_request($img->get_width(),$img->get_height());
$window->set_colormap($window->get_screen->get_rgba_colormap());
$window->show_all();
Gtk2->main;

sub expose {
	my($widget, $event) = @_;
	my $cr = Gtk2::Gdk::Cairo::Context->create($widget->window);
	$cr->set_operator("source");
	$cr->set_source_surface($img,0,0);
	$cr->paint;
	print "";
}

sub mouse{
	my ($widget, $event) = @_;
	if($event->button eq 1){
		$window->begin_move_drag($event->button,$event->x_root,$event->y_root,$event->time);
	}
	else {exit;}
}

