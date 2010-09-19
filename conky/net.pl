#!/usr/bin/perl

$f="/proc/net/route";
open ROUTE,$f; @_=<ROUTE>;close ROUTE;
@_=grep /0001/, @_;
$_=$_[0];
s/\s.*$//g;
chomp;
$s=/eth/?"▄$_":"◢\${wireless_link_qual_perc $_}%";
print "\${tab 80}\${downspeedgraph $_ 20,80 000000 00ff00}\${upspeedgraph $_ 20,80 000000 ff0000}
\${voffset -30}\${color3}网络\${color} ▼\${downspeedf $_}K\${tab 80}▲\${upspeedf $_}K
\${tab 30}●\${addr $_}\${tab 80}$s";

