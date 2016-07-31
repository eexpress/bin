#!/usr/bin/perl

$name="";
@l="";
open IN,"<$ARGV[0]"; while(<IN>){
	push @l, $_;

	if(/FN:(.*)$/){$name=$1;}
	elsif (/FN;CHARSET=UTF-8;ENCODING=QUOTED-PRINTABLE:(.*)$/){
		print "line=".$_."\n";
		$_=$1; s/=//g; $name=pack("H*",$_);
	}
	$name=~s/\x0d//;
	$name=~s/\xd0//;
	if(/END:VCARD/){
		print "name=".$name."\n";
		open OUT,">$name.vcf"; print OUT @l; close OUT;
		@l=""; $name="";
	}
}
close IN;

