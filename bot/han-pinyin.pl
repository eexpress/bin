#!/usr/bin/perl -w
use strict;
use Lingua::Han::PinYin;

my $h2p = new Lingua::Han::PinYin();

foreach ($ARGV[0]) {
my @result = $h2p->han2pinyin("$_");
print "$_ : @result\n";
}

