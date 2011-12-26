#!/usr/bin/perl
# Author: Todd Larason <jtl@molehill.org>
# modify: eexpress
# display the colors

# first the system ones:
print "System colors: 0-15
";
for ($color = 0; $color < 16; $color++) {
    printf "[48;5;${color}m%3s",${color};
}
print "[0m
";
print "
";

# now the color cube
print "Color cube, 6x6x6: 16-231
";
for ($green = 0; $green < 6; $green++) {
    for ($red = 0; $red < 3; $red++) {
   for ($blue = 0; $blue < 6; $blue++) {
       $color = 16 + ($red * 36) + ($green * 6) + $blue;
       printf "[48;5;${color}m %3s",${color};
   }
   print "[0m ";
    }
    print "
";
}
print "
";
for ($green = 0; $green < 6; $green++) {
    for ($red = 3; $red < 6; $red++) {
   for ($blue = 0; $blue < 6; $blue++) {
       $color = 16 + ($red * 36) + ($green * 6) + $blue;
       printf "[48;5;${color}m %3s",${color};
   }
   print "[0m ";
    }
    print "
";
}
print "
";


# now the grayscale ramp
print "Grayscale ramp: 232-255
";
for ($color = 232; $color < 256; $color++) {
    printf "[48;5;${color}m %03s",${color};
    if(!(($color-231)%6)){print "[0m
";}
}
print "[0m
";

