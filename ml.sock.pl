#!/usr/bin/perl  
  
use IO::Socket::INET;  
use Number::Format qw/format_bytes/;
  
my $sock = IO::Socket::INET->new(PeerAddr => 'localhost', PeerPort => 4000) or die "没找到mlnet的端口。\n";  

print "--命令: vd bw_toggle s vr help ? kill q ...-->";
while(<>){
last if /^quit|^exit|^q$/;
print $sock $_;
$vr=/vr/?1:0;
$vd=/vd/?1:0;
while(<$sock>){last if /^>/;}
print $_;
while(<$sock>){last if /command-line/;
if($vr){
s/]\ (\d)/]  $1/; @_=split /\s{2,}/;
next if $_[2]!~/^\d+$/; next if $_[2]<10000000;
$_=$_[0].$_[1]."  ".format_bytes($_[2])."  ".substr($_[4],0,50)."\n";
}
if($vd){
next if /Rate|files/;
if(/\[[DBT]/){
s/].*mldonkey/] /; @_=split /\s{2,}/;
$_="$_[0] $_[1]  $_[3]%  $_[4]/$_[5]  ".substr($_[2],0,50)."\n";
}
}
print $_;
}
print "--命令-->";
}
close $sock;  

