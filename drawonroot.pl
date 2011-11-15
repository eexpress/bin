#!/usr/bin/perl

use Gtk2 "-init";
use Cairo;
use utf8;
use X11::Protocol;

my $x = X11::Protocol->new();
my $desktop;

my ($root,undef,@kids)=$x->QueryTree($x->{'root'});
printf "%10x:\tRoot\n", $root;
foreach (@kids){
my $gdkw = Gtk2::Gdk::Window->foreign_new($_);
printf ("%10x:\tDesktop\n",$gdkw->get_xid),$desktop=$gdkw,last if $gdkw->get_type_hint eq 'desktop';
}
$desktop=Gtk2::Gdk::Window->foreign_new($root) if ! $desktop;
#------------------------------------------

#$desktop=Gtk2::Gdk::Window->foreign_new(0x380afbd);
$desktop = Gtk2::Gdk::Screen->get_default->get_active_window;
my ($x, $y, $width, $height, $depth) = $desktop->get_geometry;
printf "%10x:\tFind\t$width x $height + $x + $y \@ $depth\n", $desktop->get_xid;
my ($drawable,$x_offset,$y_offset)=$desktop->get_internal_paint_info;

Gtk2->init;
$cr = Gtk2::Gdk::Cairo::Context->create ($drawable);
cairo();
Gtk2->main_iteration;

sub cairo {
#$cr->select_font_face("Vera Sans YuanTi",'normal','bold');
#$cr->set_font_size(40);
#$cr->set_source_rgba(0,0,70,0.5);
#$cr->move_to(10,$height/2);
#$cr->show_text(`date`);

#my $img = Cairo::ImageSurface->create_from_png ('/usr/share/pixmaps/gnome-logo-large.png');
my $img = Cairo::ImageSurface->create_from_png ('/home/eexp/图片/eexp.png');
$cr->set_source_surface($img,($width-$img->get_width)/2,($height-$img->get_height)/2);
$cr->paint;

}

