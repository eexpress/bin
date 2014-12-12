#!/usr/bin/perl
# Author: Todd Larason <jtl@molehill.org>
# modify: eexpress@163.com
# display the colors

# first the system ones:
print "System colors: 0-15\n";
for ($color = 0; $color < 16; $color++) {
	$tc=(7-$color%8);
	printf "[38;5;${tc};48;5;${color}m %2s ",sprintf "%02X", ${color};
}
print "[0m\n";
print "\n";

# now the color cube
# \e[38;5;xx -> 256 text color, \e[48;5;xx -> 256 back color.
print "Color cube, 6x6x6: 16-231\n";
for ($green = 0; $green < 6; $green++) {
	for ($red = 0; $red < 3; $red++) {
	for ($blue = 0; $blue < 6; $blue++) {
	   $color = 16 + ($red * 36) + ($green * 6) + $blue;
	   $tc = 16 + ((5-$red) * 36) + ((5-$green) * 6) + (5-$blue);
	   printf "[38;5;${tc};48;5;${color}m %2s ",sprintf "%02X", ${color};
	}
	print "[0m ";
	}
	print "\n";
}
print "\n";

for ($green = 0; $green < 6; $green++) {
	for ($red = 3; $red < 6; $red++) {
	for ($blue = 0; $blue < 6; $blue++) {
	   $color = 16 + ($red * 36) + ($green * 6) + $blue;
	   $tc = 16 + ((5-$red) * 36) + ((5-$green) * 6) + (5-$blue);
	   printf "[38;5;${tc};48;5;${color}m %2s ",sprintf "%02X", ${color};
	}
	print "[0m ";
	}
	print "\n";
}
print "\n";


# now the grayscale ramp
print "Grayscale ramp: 232-255\n";
	$tc=256;
for ($color = 232; $color < 256; $color++) {
	$tc--;
    printf "[38;5;${tc};48;5;${color}m %2s ",sprintf "%02X", ${color};
    if(!(($color-231)%6)){print "[0m\n";}
}
print "[0m\n";

