#!/usr/bin/perl
# express@163.com

$bold="\e[1m"; $boldrev="\e[1;7m"; $boldund="\e[1;4m"; $end="\e[0m"; $dimrev="\e[2;7m";
$prefix="${dimrev}\\e[${end}"; $suffix="${dimrev}m${end}";

print <<"END";
ESCAPE:\tprefix -> ${prefix}  ${dimrev}\\x1b[${end}  ${dimrev}\\033[${end}\tsuffix -> ${suffix}
Format:\t${boldund}1${end} Bold ${boldund}2${end} Dim ${boldund}4${end} Underline ${boldund}5${end} Blink ${boldund}7${end} Reverse ${boldund}8${end} Hidden(password)
\t${boldund}2x${end} Reset above attributes; ${boldund}0${end} Reset all attributes, \\e[0m

Example: ${prefix}31;44;1;5${suffix} --> red fg + blue bg + blod + blink
END
print "-"x80;
print "\n16 Colors:\t${prefix} ${boldrev}3/4/9/10${end} ${boldrev}0-7${end} ${suffix}\n\n";
print "1st group. ${bold}Fg${end}=3, ${boldrev}Bg${end}=4\t\t2nd group. ${bold}Fg${end}=9, ${boldrev}Bg${end}=10 \n";
for ($color = 0; $color < 16; $color++) {
	$textcolor=(7-$color%8);
	$index=$color%8;
	print "$end\t" if $color eq 8;
	printf "\e[38;5;${textcolor};48;5;${color}m $index ";
#        printf "\e[38;5;${textcolor};48;5;${color}m %s",sprintf "%d-%d", ${color}, $index;
}
print "$end\n".("-"x80)."\n";

print "256 Colors:\t${prefix} ${boldrev}3/4${end} ${dimrev}8;5;${end} ${boldrev}0-255${end} ${suffix}\t${bold}Fg${end}=38;5;  ${boldrev}Bg${end}=48;5;\n\n";

for $index (0,3){
for ($green = 0; $green < 6; $green++) {
	for ($red = $index; $red < $index+3; $red++) {
	for ($blue = 0; $blue < 6; $blue++) {
	   $color = 16 + ($red * 36) + ($green * 6) + $blue;
	   $textcolor = 16 + ((5-$red) * 36) + ((5-$green) * 6) + (5-$blue);
	   printf "\e[38;5;${textcolor};48;5;${color}m %3d", ${color};
	}
	print "$end "; }
	print "\n"; }
print "\n"; }

$textcolor=256;
for ($color = 232; $color < 256; $color++) {
    printf "\e[38;5;${textcolor};48;5;${color}m %2s",sprintf "%03d", ${color};
    if(!(($color-231)%12)){$textcolor=0;print "$end\n";}
}
print "$end\n";

