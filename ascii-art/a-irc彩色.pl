#!/usr/bin/perl

use Encode qw(_utf8_on _utf8_off);

srand();
$_=join ' ',@ARGV;
_utf8_on($_);
@_=split //,$_;
foreach(@_){
$r=int rand(15);
#print "\.$_";
_utf8_off($_);
print "\x03$r$_";
}
print "\n";

