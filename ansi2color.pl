#!/usr/bin/perl

use Getopt::Long;
GetOptions('html'=>\$html,'tex'=>\$tex);

my @hc=qw /000000 FF0000 00FF00 FFFF00 0000FF FF00FF 00FFFF FFFFFF/;
my @c=qw /black red green yellow blue magenta cyan white/;
my @l;

while(<STDIN>){
if($html){
	s/\ /&nbsp;/g;
	s/\e\[(.*?)m/get_html_color($1)/eg;
	s/$/<br>/g;
}elsif($tex){
	s/[\#\$\%\&\~\_\{\}]/\\$&/g;
	s/\ /\\hspace{6pt}/g;
	s/\e\[(.*?)m/get_tex_color($1)/eg;
	s/$/\n/g;
}else{
	s/\e\[(.*?)m/"<".get_none_color($1).">"/eg;
}
push @l,$_;
}
#------------------------------------------------
if($tex){
print "\\colorbox{black}{
\\parbox{\\textwidth}{
\\ttfamily
@l
}}";
exit;
}
if($html){
print "<html>
<head>
<title>ansi convert to html</title>
<meta http-equiv=\"content-type\" content=\"text/html; charset=UTF-8\">
</head>
<body bgcolor=\"#333333\" text=\"#ffffff\">
@l
</body>
</html>
";
exit;
}
print @l;
#------------------------------------------------
sub get_none_color{
my $r;
for(split ';', shift){
return "normal-" if /^0$/;
$r.="bold-" if /^01/;
$r.="$c[$']-" if /^3/;
$r.="back_$c[$']-" if /^4/;
}
return $r;
}
#------------------------------------------------
sub get_tex_color{
my $r;
for(split ';', shift){
return "\\mdseries\\color[HTML]{$hc[7]}" if /^0$/;
#return "\\normalfont" if /^0$/; # 全恢复，影响中文字体
$r.="\\bfseries " if /^01/;
$r.="\\color[HTML]{$hc[$']}" if /^3/;
#$r.="back_$c[$']-" if /^4/;
}
return $r;
}
#------------------------------------------------
sub get_html_color{
my $r;
for(split ';', shift){
return "</b></font>" if /^0$/;
$r.="<b>" if /^01/;
$r.="<font color=\"#$hc[$']\">" if /^3/;
#$r.="back_$c[$']-" if /^4/;
}
return $r;
}
#------------------------------------------------

