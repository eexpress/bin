#!/usr/bin/perl

open(Deb,"aptitude show $ARGV[0]|");
while(<Deb>){
chomp;
	if(/软件包|版本|尺寸|描述|Package|Version|Size|Description/) {
		s/^\S*\s*//; print "$_ ► ";
		if($&=~/描述|Description/){
			while(<Deb>){last if /^\s*$/; chomp; print;}
		}
	}
}
close(Deb);
