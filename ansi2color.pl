#!/usr/bin/perl

my @hc=qw /000000 FF0000 00FF00 FFFF00 0000FF FF00FF 00FFFF FFFFFF/;
my @c=qw /black red green yellow blue magenta cyan white/;

print "\\colorbox{black}{
\\parbox{\\textwidth}{
\\ttfamily
";

while(<STDIN>){
s/[\#\$\%\&\~\_\{\}]/\\$&/g;
s/\ /\\hspace{6pt}/g;
#s/\e\[(.*?)m/" ".getcolorname($1)." "/eg;
s/\e\[(.*?)m/gethtmlcolorname($1)/eg;
s/$/\n/g;
print;
}
print "}}";

sub getcolorname{
my $r;
for(split ';', shift){
return "normal-" if /^0$/;
$r.="bold-" if /^01/;
$r.="$c[$']-" if /^3/;
$r.="back_$c[$']-" if /^4/;
}
return $r;
}

sub gethtmlcolorname{
my $r;
for(split ';', shift){
return "\\mdseries\\color[HTML]{$hc[7]}" if /^0$/;
#return "\\normalfont" if /^0$/;
$r.="\\bfseries " if /^01/;
$r.="\\color[HTML]{$hc[$']}" if /^3/;
#$r.="back_$c[$']-" if /^4/;
}
return $r;
}
