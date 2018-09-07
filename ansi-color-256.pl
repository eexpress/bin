#!/usr/bin/perl
# Author: Todd Larason <jtl@molehill.org>
# modify: eexpress@163.com
# display the colors
$bold="\e[1m"; $boldrev="\e[1;7m"; $boldund="\e[1;4m"; $end="\e[0m";

print "ESCAPE:\t\\e  \\x1b  \\x33\nFormat:\t1 Bold 2 Dim 4 Underline 5 Blink 7 Reverse(invert fg and bg) 8 Hidden(password)\n\t${boldund}2x${end} Reset above attributes; ${boldund}0${end} Reset all attributes, \\e[0m\n\n";
print "16 Colors:\t\\e[${boldrev}3/4/9/10${end}[0-7]m\t${bold}Fg${end}=3/9\t${boldrev}Bg${end}=4/10\n\n";
for ($color = 0; $color < 16; $color++) {
	$tc=(7-$color%8);
	$index=$color%8;
	print "\e[0m\t" if $color eq 8;
	printf "\e[38;5;${tc};48;5;${color}m $index ";
#        printf "\e[38;5;${tc};48;5;${color}m %s",sprintf "%d-%d", ${color}, $index;
}
print "$end\n\n";

print "256 Colors:\t\\e[${boldrev}3/4${end}8;5;[0-255]m\t${bold}Fg${end}=3\t${boldrev}Bg${end}=4\n\n";

for $index (0,3){
for ($green = 0; $green < 6; $green++) {
	for ($red = $index; $red < $index+3; $red++) {
	for ($blue = 0; $blue < 6; $blue++) {
	   $color = 16 + ($red * 36) + ($green * 6) + $blue;
	   $tc = 16 + ((5-$red) * 36) + ((5-$green) * 6) + (5-$blue);
	   printf "\e[38;5;${tc};48;5;${color}m %3d", ${color};
	}
	print "$end "; }
	print "\n"; }
print "\n"; }

$tc=256;
for ($color = 232; $color < 256; $color++) {
    printf "\e[38;5;${tc};48;5;${color}m %2s",sprintf "%03d", ${color};
    if(!(($color-231)%12)){$tc=0;print "$end\n";}
}
print "$end\n";

