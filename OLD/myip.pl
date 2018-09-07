#!/usr/bin/perl

use LWP::Simple;
$content = get("http://ifconfig.me/ip");
die "Couldn't get it!" unless defined $content;
print $content;
