#!/usr/bin/perl
# Author: Todd Larason <jtl@molehill.org>
# modify: eexpress@163.com
# display the colors

print "ESCAPE:\t\\e  \\x1b  \\x33\nFormat:\t1 Bold 2 Dim 4 Underline 5 Blink 7 Reverse(invert fg and bg) 8 Hidden(password)\n\t\e[1;4m2x\e[0m Reset above attributes; \e[1;4m0\e[0m Reset all attributes\nCOLOR:\t\e[1mFg\e[0m 39 3[0-7] 9[0-7] \e[1;7mBg\e[0m 49 4[0-7] 10[0-7] \e[1;4mx9\e[0m for default color\n256 C:\t\e[1mFg\e[0m 38;5;[1-256] \e[1;7mBg\e[0m 48;5;[1-256]\n---------------\n";
for ($color = 0; $color < 16; $color++) {
	$tc=(7-$color%8);
	$index=$color%8;
	print "\e[0m    " if $color eq 8;
	printf "\e[38;5;${tc};48;5;${color}m %s",sprintf "%d-%d", ${color}, $index;
}
print "\e[0m\n";
print "\n";

for ($green = 0; $green < 6; $green++) {
	for ($red = 0; $red < 3; $red++) {
	for ($blue = 0; $blue < 6; $blue++) {
	   $color = 16 + ($red * 36) + ($green * 6) + $blue;
	   $tc = 16 + ((5-$red) * 36) + ((5-$green) * 6) + (5-$blue);
	   printf "\e[38;5;${tc};48;5;${color}m %2s",sprintf "%03d", ${color};
	}
	print "\e[0m ";
	}
	print "\n";
}
print "\n";

for ($green = 0; $green < 6; $green++) {
	for ($red = 3; $red < 6; $red++) {
	for ($blue = 0; $blue < 6; $blue++) {
	   $color = 16 + ($red * 36) + ($green * 6) + $blue;
	   $tc = 16 + ((5-$red) * 36) + ((5-$green) * 6) + (5-$blue);
	   printf "\e[38;5;${tc};48;5;${color}m %2s",sprintf "%03d", ${color};
	}
	print "\e[0m ";
	}
	print "\n";
}
print "\n";

$tc=256;
for ($color = 232; $color < 256; $color++) {
	$tc--;
    printf "\e[38;5;${tc};48;5;${color}m %2s",sprintf "%03d", ${color};
    if(!(($color-231)%12)){print "[0m\n";}
}
print "\e[0m\n";

