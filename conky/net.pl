#!/usr/bin/perl

@_=`route`;
@_=grep /\*/, @_;
$_=$_[0];
s/.*\ //g;
chomp;
print "\${tab 80}\${downspeedgraph $_ 20,80 000000 00ff00}\${upspeedgraph $_ 20,80 000000 ff0000}
\${voffset -30}\${color3}网络\${color}   ▼\${downspeedf $_}K\${tab 80}▲\${upspeedf $_}K
\${color3}$_\${color}\${tab 20}●\${addr $_}\${tab 80}◢\${wireless_link_qual_perc $_}%";

