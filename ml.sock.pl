#!/usr/bin/perl  
  
use IO::Socket::INET;  
  
my $sock = IO::Socket::INET->new(PeerAddr => 'localhost', PeerPort => 4000) or die "没找到mlnet的端口。\n";  

print "--命令: vd bw_toggle s vr help kill etc.-->";
while(<>){
last if /^quit|^exit/;
print $sock $_;
$vr=/vr/?1:0;
while(<$sock>){last if /^>/;}
print $_;
while(<$sock>){last if /command-line/;
use Number::Format qw/format_bytes/;
if($vr){
s/]\ (\d)/]  $1/; @_=split /\s{2,}/;
next if $_[2]!~/^\d+$/; next if $_[2]<10000000;
$_=$_[0].$_[1]."  ".format_bytes($_[2])."  ".substr($_[4],0,50)."\n";
}
print $_;
}
print "--命令-->";
}
close $sock;  

