#!/usr/bin/perl

use Gtk2 "-init";
use Cairo;
use utf8;

#$file='/home/eexp/图片/120px-Former_Ubuntu_logo.svg.png';
$file=$ARGV[1]//'/home/eexp/图片/壁纸●/1920vladstudio_1019.jpg';
Gtk2->init;
$display=Gtk2::Gdk::Display->get_default;
$screen = $display->get_default_screen;
#$screen=Gtk2::Gdk::Screen->get_default;
$window=$screen->get_root_window;
#$window=Gtk2::Gdk->get_default_root_window;

#Gtk2::Gdk::DisplayManager->get->get_default_display
#print $window->get_width; exit;
#$window->set_events("GDK_EXPOSURE_MASK");
#Gtk2::Gdk::Event->handler_set (sub {
#        ($event) = @_;
#        print "GDK-EVENT\n";
#        if($event->type=="GDK_EXPOSURE"){cairo();}
#        });
$pixbuf = Gtk2::Gdk::Pixbuf->new_from_file ($file);
$pixmap = $pixbuf->render_pixmap_and_mask (1);
$window->set_back_pixmap($pixmap,0);
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
$cr->set_font_size(160);
$cr->set_source_rgba(0,0,70,0.5);
$cr->move_to(100,200);
$cr->show_text("Cairo on Root");

#my $img = Cairo::ImageSurface->create_from_png ($file);
#$cr->set_source_surface($img,200,300);
#$cr->paint;
#print ".";
}
