#!/usr/bin/perl

use utf8;
use open qw(:std :utf8);
use LWP::UserAgent;
my $ua = LWP::UserAgent->new( agent => 'Opera/9.80', timeout => 10 );
use Net::DBus;
#▶ ai libnet-dbus-perl
my $bus = Net::DBus->session->get_service('org.freedesktop.Notifications')->get_object('/org/freedesktop/Notifications','org.freedesktop.Notifications');
#输入编号
$_=$ARGV[0];
$_=`xsel -o` if !$_;
m/\w{2,4}-\d{3,4}/; $s=$&;
die "not correct id." if !$s;
print "> $s <\n";
open OUT,">>/tmp/bt.log"; print OUT ". $s .\n"; close OUT;
#--------------------------------------------
#$web="https://thepiratebay.se";
#$url="$web/search/$s/";
$web="https://kickass.to";
$url="$web/usearch/$s/";

print "1 ->\t$url\n"; $response = $ua->get($url);
if ( $response->is_success ) {
	$_=$response->decoded_content;
	/magnet:[^"]*/; $_=$&; $_.="\n"; print;
	if(/magnet/){
		`transmission-remote -a "$_"`;
		if($?>0){open OUT,">>$ENV{HOME}/magnet.list"; print OUT "--\t$s\n$_"; close OUT; print "Add to transmission retrun error: $?. Save magnet to ~/magnet.list.\n";}
		if($?>0){$bus->Notify("bt", 0, "sunny", "Add to transmission retrun error: $?. Save magnet to ~/magnet.list.\n", "", [], { }, -1);}
		exit;
	}
}
#--------------------------------------------
#No BT link now
$url="http://blog.jav4you.com/?s=$s";
print "1 ->\t$url\n"; $response = $ua->get($url);
die "Couldn't get it!" unless $response->is_success;
$_=$response->decoded_content;
/href=.*?Read the rest of this entry/;
#<a href="http://blog.jav4you.com/2014/02/mdyd-866-real-wives-only-non-fictional-trip-of-cheating-3/#more-36500" class="more-link">Read the rest of this entry »</a>
$_=$&; m'http://[^"]*';
$url=$&; print "2 ->\t$url\n"; $response = $ua->get($url);
die "Couldn't get it!" unless $response->is_success;
$_=$response->decoded_content;
#<p><b>BitTorrent File</b><br><a href="http://l.jav4you.com/1eQ2eLT" target="_blank" rel="nofollow">ishrhndug.html</a><br><br><br></p>
#open OUT,">>$ENV{HOME}/bt.log"; print OUT $content; close OUT;
/BitTorrent File.*html/;
$_=$&; s/.*>//;
#$url="http://www.21stp.com/$_";
if($_==""){
	$bus->Notify("bt", 0, "sunny", "No BT link found.", "", [], { }, -1);
	die "No BT link found.";
}
$url="http://www.2121.club/$_";
print "3 ->\t$url\n";
`gnome-open \'$url\'`; exit;
#--------------------------------------------

