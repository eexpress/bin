#!/usr/bin/perl

use File::Temp qw(tempdir mktemp);
use File::Spec::Functions qw(catfile);
use POSIX qw(mkfifo);

my $t=mktemp("VF-XXXXX");
my $dir = tempdir(CLEANUP=>1);
my $fifo = catfile($dir, "fifo");
mkfifo($fifo, 0700) or die "mkfifo($fifo) failed: $!";
print "$t;\t$dir;\t$fifo;\n";
exit;
open(INFO,"mplayer -slave -input file=$fifo -quiet -idle $ARGV[1] |");
while(<>){
last if /^quit|^exit|^q$/;
#print $fifo, $_;
#print <INFO>;
};
close(INFO);

#http://mplayerhq.hu/pipermail/mplayer-users/2003-July/034663.html
