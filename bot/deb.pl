#!/usr/bin/perl
use Switch;

#open(Deb,"aptitude show $ARGV[0]|");
#while($line=<Deb>){
#chomp($line);
#if($line=~/软件包|版本|尺寸|描述|Package|Version|Size|Description/) {
#if($& ne "描述")
#{$line=~s/^\S*\s*//; print "$line ► ";next;}
#$line=<Deb>;print "$line";last;
#}
#}
#close(Deb);

open(Deb,"aptitude show $ARGV[0]|");
while(<Deb>){
chomp;
if(/软件包|版本|尺寸|描述|Package|Version|Size|Description/) {
s/^\S*\s*//; print "$_ ► ";
if($&=~/描述|Description/){
my $ll=<Deb>; print $ll; last;
}
}
}
close(Deb);
