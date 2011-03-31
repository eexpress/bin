#!/usr/bin/perl

my $Select=$ARGV[0];
use Config::IniFiles;
my $cfg = new Config::IniFiles( -file => "$ENV{HOME}/.tray.rc" );
die "No Select Profile.\n" if(! $cfg->val($Select,'act0'));
#----------------------------------
my $st=0;
use Gtk2 "-init"; 
use Encode;
#$SIG{CHLD} = 'IGNORE';
my $status_icon = Gtk2::StatusIcon->new;
$status_icon->set_tooltip(decode("utf8",$cfg->val($Select,'tip')));
#$_=$cfg->val($Select,'pic0'); print "$_\n";
$status_icon->set_from_file($cfg->val($Select,'pic0'));
$status_icon->signal_connect('button_release_event',\&click);
$status_icon->signal_connect('scroll_event',\&scroll);
$status_icon->set_visible(1);
Gtk2 -> main;
#----------------------------------
sub click{
my ($check, $event) = @_;
if($event->button eq 1 || $event->button eq 3){
	system($cfg->val($Select,"act$st"));
#        if(fork()==0){`$_`;exit;}
	$st=$st eq 0?1:0;
	$status_icon->set_from_file($cfg->val($Select,"pic$st"));
}
if($event->button eq 2){exit;}
}
#----------------------------------
sub scroll{
my ($check, $event) = @_;
if($event->direction eq 'down'){system($cfg->val($Select,'down'));}
if($event->direction eq 'up'){system($cfg->val($Select,'up'));}
}
#----------------------------------

