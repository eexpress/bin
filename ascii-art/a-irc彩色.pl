#!/usr/bin/perl

use Encode qw(_utf8_on _utf8_off);

srand();
if($ARGV[1]){
$_=join ' ',@ARGV;
}else{
$_=`xsel -o`;
}
_utf8_on($_);
@_=split //,$_;
foreach(@_){
$r=int rand(15);
#print "\.$_";
_utf8_off($_);
$out.=sprintf "\x03$r$_";
}
print "$out\n";
`echo $out|xsel -i`;
