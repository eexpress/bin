#!/usr/bin/perl
use LWP::Simple; 
use Encode qw(encode decode);
#mtr bootstrap.upsight-api.com -r -c 1 -n|ipfilter.pl

sub ip_138{
$in=shift;
$url="http://www.ip138.com/ips138.asp?ip=".$in;
$_=get($url); $_=encode("utf8",decode("gbk",$_));
/本站主数据.*\<\/ul\>/m;
$_=$&; s'</li>'\\n'g; s'<.*?>''g;
s/\\n//g;s/本站主数据：/|/; s/参考数据一：/|/g;
s/\ //g;
return $_;
}

my $f=\&ip_138;

while (<STDIN>){
s'\d+\.\d+\.\d+\.\d+'$&.$f->($&)'ge;
print $_;
}

