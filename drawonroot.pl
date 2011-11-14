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
$desktop=Gtk2::Gdk->get_default_root_window if ! $desktop;
#● gconftool-2 -s /apps/nautilus/preferences/show_desktop false -t bool
my ($x, $y, $width, $height, $depth) = $desktop->get_geometry;
printf "%10x:\tFind\t$width x $height + $x + $y \@ $depth\n", $desktop->get_xid;

Gtk2->init;
#$pixbuf = Gtk2::Gdk::Pixbuf->new_from_file ('/home/eexp/图片/rabbit.png');
#$pixbuf1=$pixbuf->scale_simple ($width, $height, "GDK_INTERP_BILINEAR");
#$pixmap = $pixbuf1->render_pixmap_and_mask (1);

#my ($drawable,$x_offset,$y_offset)=$desktop->get_internal_paint_info;
#$pixmap = Gtk2::Gdk::Pixmap->new($drawable, $width, $height, $depth);
$pixmap = Gtk2::Gdk::Pixmap->new($desktop, $width, $height, $depth);

$cr = Gtk2::Gdk::Cairo::Context->create ($pixmap);
cairo();
#$pixbuf1->save('/home/eexp/w.jpg','jpeg',quality=>'100');
$desktop->set_back_pixmap($pixmap,0);
$desktop->clear();
Gtk2->main_iteration;
#Gtk2->main;

sub cairo {
$cr->select_font_face("Amerika",'normal','bold');
#$cr->select_font_face("Amerika Sans",'normal','bold');
$cr->set_font_size(240);
$cr->set_source_rgba(100,0,70,0.5);
$cr->move_to(100,200);
$cr->show_text("Cairo on Desktop");
print ".";
}

