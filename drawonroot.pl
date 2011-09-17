#!/usr/bin/perl

use Gtk2 "-init";
use Cairo;
use utf8;
use Data::Dumper;

#$file='/home/eexp/图片/120px-Former_Ubuntu_logo.svg.png';
#$file=$ARGV[1]//'/home/eexp/图片/壁纸●/1920vladstudio_1019.jpg';
$file=$ARGV[1]//'/home/eexp/图片/壁纸/1920x1080.jpg';
Gtk2->init;
#$display=Gtk2::Gdk::Display->open($ENV{DISPLAY});
#print "display:$display.$ENV{DISPLAY}\n";
#while (my ($k,$v)=each $$display){print "{$k}\t=> $v\n";}; print "\n";
#print Data::Dumper->Dump([[$display]]);
#$display=Gtk2::Gdk::Display->get_default;
#$screen = $display->get_default_screen;
#$screen=Gtk2::Gdk::Screen->get_default;
#$window=$screen->get_root_window;
$window=Gtk2::Gdk->get_default_root_window;
($drawable,$x_offset,$y_offset)=$window->get_internal_paint_info;
my ($x, $y, $width, $height, $depth) = $window->get_geometry;
printf "0x%x : $width x $height @ $depth\n", $window->get_xid;

# self.root_window = gtk.gdk.get_default_root_window()
#    self.root_window.set_events(gtk.gdk.ALL_EVENTS_MASK)
#    gtk.gdk.event_handler_set(self.filter_callback)
#    gtk.main()
#Gtk2::Gdk::DisplayManager->get->get_default_display
#print $window->get_width; exit;
#$window->set_events("GDK_EXPOSURE_MASK");
#Gtk2::Gdk::Event->handler_set (sub {
#        ($event) = @_;
#        print "GDK-EVENT\n";
#        if($event->type=="GDK_EXPOSURE"){cairo();}
#        });

#$pixbuf = Gtk2::Gdk::Pixbuf->new_from_file ($file);
#$pixmap = $pixbuf->render_pixmap_and_mask (1);
#$pixmap = Gtk2::Gdk::Pixmap->lookup_for_display ($display, $window);
$pixmap = Gtk2::Gdk::Pixmap->lookup($drawable);
#$pixmap = Gtk2::Gdk::Pixmap->lookup($window);
#$pixmap = Gtk2::Gdk::Pixmap->foreign_new($window);
#$pixmap = Gtk2::Gdk::Pixmap->foreign_new_for_display($display,$window);
#$pixmap = Gtk2::Gdk::Pixmap->foreign_new_for_screen ($screen, $window, $width, $height, $depth);
#$pixmap = Gtk2::Gdk::Pixmap->lookup_for_display ($display, $window);
#$pixmap = Gtk2::Gdk::Pixmap->lookup($drawable);
#$window->set_back_pixmap($pixmap,0);
$cr = Gtk2::Gdk::Cairo::Context->create ($pixmap);

#$cr=Gtk2::Gdk::Cairo::Context->create($window);
#Glib::Timeout->add_seconds(1,\&cairo);
cairo();
#Gtk2->main_iteration while Gtk2->events_pending;
#Gtk2->main();
$window->set_back_pixmap($pixmap,0);
$window->clear();
#$display->flush;
Gtk2->main_iteration;

sub cairo {
$cr->select_font_face("Amerika Sans",'normal','bold');
$cr->set_font_size(140);
$cr->set_source_rgba(0,0,70,0.5);
$cr->move_to(100,200);
$cr->show_text("Cairo on Root");

#my $img = Cairo::ImageSurface->create_from_png ($file);
#$cr->set_source_surface($img,200,300);
#$cr->paint;
#print ".";
}

#log
#● gconftool-2 -s /apps/nautilus/preferences/show_desktop true -t bool
#● xwininfo >nautilus
#● gconftool-2 -s /apps/nautilus/preferences/show_desktop false -t bool
#● xwininfo >root
#● diff nautilus root 
#6c6
#< xwininfo: Window id: 0x2002992 "x-nautilus-desktop"
#---
#> xwininfo: Window id: 0x15d (the root window) (has no name)
#20c20
#<   Bit Gravity State: NorthWestGravity
#---
#>   Bit Gravity State: ForgetGravity
#● compiz --replace &
#xwininfo results is same as metacity.
#under arch and gnome-shell
#xwininfo: Window id: 0x137 (the root window) (has no name)
#kde
#xwininfo: Window id: 0x18015bc "plasma-desktop"
#E16
#xwininfo: Window id: 0x40000c "Root-bg"
#FVWM
#xwininfo: Window id: 0xa7 (the root window) (has no name)
#Wmaker
#xwininfo: Window id: 0xa7 (the root window) (has no name
