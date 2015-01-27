#!/usr/bin/perl

use utf8;
use LWP::Simple qw($ua get);
use Net::DBus;
my $bus = Net::DBus->session->get_service('org.freedesktop.Notifications')->get_object('/org/freedesktop/Notifications','org.freedesktop.Notifications');
#输入编号
$_=$ARGV[0];
$_=`xsel -o` if !$_;
m/\w{2,4}-\d{3,4}/; $s=$&;
die "not correct id." if !$s;
print "> $s <\n";
open OUT,">>/tmp/bt.log"; print OUT ". $s .\n"; close OUT;
$ua->timeout(10);
goto JUMP;
#--------------------------------------------
$url="http://thepiratebay.ee/s/?q=$s&page=0&orderby=99";
print "1 ->\t$url\n"; $_ = get($url);
#die "Couldn't get it!" unless defined $_;
if(defined $_){
#<a href="/torrent/9278096/IPZ-260 Erika Shibasaki JAV CENSORED"
	/href=\"\/torrent.*?\"/; $_=$&; s/href=//; s/\"//g; s/\ /%20/g;
	if($_=~m'/'){
		$url="http://thepiratebay.ee$_";
		print "2 ->\t$url\n"; $_ = get($url);
#        Only registered users can use the tracker.
		/magnet:[^"]*/; $_=$&; $_.="\n";
		`transmission-remote -a "$_"`;
	if($?>0){open OUT,">>$ENV{HOME}/magnet.list"; print OUT "--\t$s\n$_"; close OUT; print "Add to transmission retrun error: $?. Save magnet to ~/magnet.list.\n";}
		print;
	if($?>0){$bus->Notify("bt", 0, "sunny", "Add to transmission retrun error: $?. Save magnet to ~/magnet.list.\n", "", [], { }, -1);}
		exit;
	}
}
#--------------------------------------------
JUMP:
$url="http://blog.jav4you.com/?s=$s";
print "1 ->\t$url\n"; $content = get($url);
#http://blog.jav4you.com/?s=MDYD-866&x=0&y=0
#Read the rest of this entry »
die "Couldn't get it!" unless defined $content;
$content=~/href=.*?Read the rest of this entry/;
#<a href="http://blog.jav4you.com/2014/02/mdyd-866-real-wives-only-non-fictional-trip-of-cheating-3/#more-36500" class="more-link">Read the rest of this entry »</a>
$_=$&; m'http://[^"]*';
$url=$&; print "2 ->\t$url\n"; $content = get($url);
die "Couldn't get it!" unless defined $content;
#<p><b>BitTorrent File</b><br><a href="http://l.jav4you.com/1eQ2eLT" target="_blank" rel="nofollow">ishrhndug.html</a><br><br><br></p>
#open OUT,">>$ENV{HOME}/bt.log"; print OUT $content; close OUT;
$content=~/BitTorrent File.*html/;
$_=$&; s/.*>//;
#$url="http://www.21stp.com/$_";
$url="http://www.2121.club/$_";
print "3 ->\t$url\n";
`gnome-open \'$url\'`; exit;

$content = get($url);
die "Couldn't get it!" unless defined $content;
#<a href="http://www.21stp.com/save/857470376/dd82969aa8">ダウンロード</a>
$content=~/href=.*?ダウンロード/;
$_=$&;
#网站修改了简单的js
#m'http://[^"]*';
m'/save[^\']*';
$url="http://www.2121.club$&"; print "4 ->\t$url\n";

`gnome-open \'$url\'`;

#$s="$ENV{HOME}/$s.torrent";
#if(is_success(getstore($url,$s))){ print "5 ->\tsave to $s\n"; }

#$content = get($url);
#die "Couldn't get it!" unless defined $content;
#open OUT,">>$s"; print OUT $content; close OUT;

#use WWW::Mechanize;
#my $mech = WWW::Mechanize->new(agent=>'Opera/9.80 (X11; Linux i686; U; en) Presto/2.6.30 Version/10.60');
#$mech -> get($url);
#if ($mech->success()) { $mech->save_content($s); print "5 ->\tsave to $s\n"; }
#`transmission-remote -a "$_"`;
#if($?>0){print "Add to transmission retrun error: $?.\n";}
