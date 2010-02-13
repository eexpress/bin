#!/usr/bin/perl
use LWP::Simple;
sub cv {
	open(CV, "|/usr/bin/enconv") or die("没有命令：enconv。\n");
	print CV $_[0];
	close CV;
}
use LWP;
use LWP::UserAgent;
my $ua = LWP::UserAgent->new();
$ua->max_size( 2 * 1024 );
my $reply = $ua->get($ARGV[0]);
my $html;
if ( $reply->is_success ) {
    $html = $reply->content;

$html=~/<title>.*?<\/title>/is;my $t=$&;$t=~s/\xa//sg;$t=~s/<.*?>//g;
$t=~s/&\w*;//g;
cv($t);print "\n";
#`echo -n $t|enconv`;
#use Encode qw/encode decode/;
#my $utf8=decode("cp936", $t);print $utf8;
}
else {die "无法获取的地址。";}
