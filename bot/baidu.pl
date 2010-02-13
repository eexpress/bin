#!/usr/bin/perl
use LWP;
use LWP::UserAgent;

my $w=join(" ",@ARGV);
#my $w=$ARGV[0];
$w=`echo "$w"|iconv -f utf8 -t gbk|uni2ascii -a J`;
chomp($w);
$w=~s/\ /+/g;
$w="http://www.baidu.com/s?wd=$w";
#print ">>>\t$w\t<<<\n";
my $ua = LWP::UserAgent->new();
$ua->max_size( 20 * 1024 );
my $reply = $ua->get("$w");
my $html;
#----------------------------------------------
if ( $reply->is_success ) {
$html = $reply->content;
my @t=$html=~/href=\"http.*?<\/a>/g;
my $n=8;
for my $s (@t){
if($s=~/www\.baidu\.com|tieba\.baidu\.com/){next;}
#if($s=~/tieba\.baidu\.com/){next;}
if($s!~/font>/){next;}
$s=~s/<.*?>//g;
$s=~s/^href=\"//;
$s=~s/\".*>/ - /g;
$s=`echo "$s"|iconv -t utf8 -f gbk`;
chomp($s); 
print "\n" if($n%3==0);
print " ► ";
#print " ＊ ";
print $s;
last if (!--$n);
}}
#----------------------------------------------
else {die "无法获取的地址。";}

