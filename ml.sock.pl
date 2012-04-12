#!/usr/bin/perl  
  
use IO::Socket::INET;  
  
my $sock = IO::Socket::INET->new(PeerAddr => 'localhost', PeerPort => 4000) or die "没找到mlnet的端口。\n";  

print "--命令: vd bw_toggle help kill etc.-->";
while(<>){
print $sock $_;
while(<$sock>){last if /^>/;}
print $_;
while(<$sock>){last if /command-line/; print $_;};
print "--命令-->";
}
close $sock;  

