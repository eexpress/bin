#!/usr/bin/perl

my $Bred="\e[1;31m"; my $Bblue="\e[1;34m"; my $normal="\e[0m";
$log='/var/log/dpkg.log';
$re='\d\s(install|remove)';

open IN,$log.".1"; @_=grep /$re/,<IN>; close IN;
open IN,$log; @tmp=grep /$re/,<IN>; close IN;
push @_,@tmp;
#print @_;
for(@_){
	s/(install|remove)\s[^:]*\K\:.*//;
	s/install/$Bblue$&/g;
	s/remove/$Bred$&/g;
	s/$/$normal/;
	print;
}
