#!/usr/bin/perl

use LWP::UserAgent;
my $url=shift;
my $ua=new LWP::UserAgent();
my $re= $ua->get($url);
die if (!$re->is_success);
my $html= $re->content;

#print $html;
#得到页面中所有链接
while($html=~m{<a .*?href=(["'])(.*?)\1.*?>(<.*?/>)*(.*?)</a>}gsi){
print "$2\t--->$4\n";
#my $l=$2; my $t=$4;if($l=~/^http/ and $l!~/com\/$|cn\/$/ and $t!~/^</){print "$l\t--->$t\n";}
}

