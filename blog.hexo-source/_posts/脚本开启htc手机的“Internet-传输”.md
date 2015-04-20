title: 脚本开启htc手机的“Internet 传输”
date: 2013-08-28 09:11
tags:
- reverse-tethering
- htc
- android 
---
``` bash
● cat htcsock.pl
use IO::Socket::INET; 
do{
open IN,"/proc/net/arp"; @arp=<IN>; close IN;
@d=grep ! /00:00:00:00:00:00/,grep /0x2.*usb0/,@arp;
} until($d[0]);
$_=$d[0]; s/\ .*//; chomp; print "sock:\t$_\n";
my $sock = IO::Socket::INET->new(PeerAddr => $_ , PeerPort => 6000, Type=>SOCK_STREAM, Proto=>"tcp") or die "socket connect fail. $@\n"; 
print $sock "\x00\x02\x00\x00"; receivesock();
print $sock "\x00\x03\x00\x00"; receivesock();
print $sock "\x00\x05\x00\x00";
close $sock; 
sub receivesock{
local $/=\4;
print "Receive: --"; print unpack "H*",<$sock>; print "--\n";
}
```
思路是qileilu折腾出来的。

