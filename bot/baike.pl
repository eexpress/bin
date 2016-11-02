#!/usr/bin/perl
use LWP;
use LWP::UserAgent;
use Encode;
use POSIX qw(isatty);
my $ua = LWP::UserAgent->new();
$ua->max_size( 180 * 1024 );
$in=`xsel -o`;
if($ARGV[0]){$in=$ARGV[0];}
$icon='/usr/share/icons/gnome/48x48/actions/system-search.png';

my $reply = $ua->get("http://baike.baidu.com/item/$in");
my $html;
if($reply->is_success){
		$html = $reply->content;
		$html=~/"lemmaSummary">(.*?)<div class="configModuleBanner"/s;
		$_=$1;
		s/<.*?>//g; s/\r//g; s/&.*?;//g; s/\n//g;
		if (isatty(0)){
			print; print "\n";
		} else {
			`notify-send -i $icon "$in" "$_"`;
		}
}
