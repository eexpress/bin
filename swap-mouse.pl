#!/usr/bin/perl

use utf8;
use Gtk2 -init;

use File::Basename qw/basename dirname/;
$path=$0;
$path=readlink $0 if -l $0;
$path=dirname $path;
chdir $path;

my $icon_l="left.png";
my $icon_r="right.png";

sub swap_mouse{
my ($check, $event) = @_;
if($event->button eq 2){exit;}
#        my ($widget, $button, $time, $menu) = @_;
#        $r=`xmodmap -pp|grep "\<3\>\s*\<1\>"`;
if($r eq "left"){
	`xmodmap -e "pointer = 1 2 3"`;
	`xsetroot -cursor_name left_ptr`;
	print "right hand\n";
	$r="right";
	$status_icon->set_from_file($icon_r);
}
else{
	`xmodmap -e "pointer = 3 2 1"`;
	`xsetroot -cursor_name right_ptr`;
	print "left hand\n";
	$r="left";
	$status_icon->set_from_file($icon_l);
}
}

$r=`xmodmap -pp|grep "\<3\>\s*\<1\>"`;
if($r){
$status_icon = Gtk2::StatusIcon->new_from_file($icon_r);
$r="right";
}
else{
$status_icon = Gtk2::StatusIcon->new_from_file($icon_l);
$r="left";
}
$status_icon->signal_connect('button-press-event',\&swap_mouse);
$status_icon->set_visible(1);
Gtk2->main();
