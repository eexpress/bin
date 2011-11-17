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
$display=Gtk2::Gdk::Display->get_default;
$file=$ARGV[0]//'/usr/share/pixmaps/gnome-logo-large.png';
cairo();
#gc();
#pixmap();
Gtk2->main_iteration;
#Gtk2->main;

sub pixmap{
$pixbuf=Gtk2::Gdk::Pixbuf->new_from_file($file);
$pixbuf1=$pixbuf->scale_simple ($width, $height, "GDK_INTERP_BILINEAR");
$pixmap = $pixbuf1->render_pixmap_and_mask (1);
$cr = Gtk2::Gdk::Cairo::Context->create ($pixmap);
cairo();
$display->flush;
$desktop->set_back_pixmap($pixmap,0);
$desktop->clear();
$display->flush;

}
sub gc{
$gc = Gtk2::Gdk::GC->new ($desktop, undef);

$pixbuf=Gtk2::Gdk::Pixbuf->new_from_file($file);
($format,$pw,$ph)=$pixbuf->get_file_info($file);
$pixbuf->render_to_drawable($drawable,$gc,0,0,100,100,$pw,$ph,'normal',0,0);
}
sub cairo {
$cr = Gtk2::Gdk::Cairo::Context->create ($drawable);
#$cr->select_font_face("Vera Sans YuanTi",'normal','bold');
#$cr->set_font_size(40);
#$cr->set_source_rgba(0,0,70,0.5);
#$cr->move_to(10,$height/2);
#$cr->show_text(`date`);

#my $img = Cairo::ImageSurface->create_from_png ('/usr/share/pixmaps/gnome-logo-large.png');
my $img = Cairo::ImageSurface->create_from_png ($file);
$cr->set_source_surface($img,($width-$img->get_width)/2,($height-$img->get_height)/2);
$cr->paint;

}

