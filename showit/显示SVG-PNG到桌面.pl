#!/usr/bin/perl

#此脚本放入 ~/.local/share/nautilus/scripts/ 目录。

use 5.010;
use MIME::Types;

my @files = split("\n", $ENV{NAUTILUS_SCRIPT_SELECTED_FILE_PATHS});
$types = MIME::Types->new;
#open OUT,">$ENV{HOME}/script.txt";

foreach my $file (@files)
{
$m=$types->mimeTypeOf($file);
if($m eq "image/png" || $m eq "image/svg+xml"){
	system ("/home/eexpss/bin/showit/showsvgpngtxt $file &");
}
#print OUT $m."\t\t".$file."\n";
}
#close OUT;
