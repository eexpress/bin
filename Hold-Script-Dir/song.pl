#!/usr/bin/perl -w

use Net::DBus;
use Data::Dumper;

my $shell = Net::DBus->session->get_service('org.gnome.Rhythmbox')->get_object('/org/gnome/Rhythmbox/Shell','org.gnome.Rhythmbox.Shell');
$shell->notify("1");
my $bus = Net::DBus->session->get_service('org.gnome.Rhythmbox')->get_object('/org/gnome/Rhythmbox/Player','org.gnome.Rhythmbox.Player');
$_=$bus->getPlayingUri();
@_=$shell->getSongProperties($_);
s/%(..)/pack("U", hex($1))/eg;
s/.*\///g;
print "♫ $_";
print "\n\n"; print Dumper(@_);

