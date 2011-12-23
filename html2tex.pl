#!/usr/bin/perl

$_=`mimetype $ARGV[0]`;
die "$ARGV[0] is not an html file." if ! m"text/html";
open RC,"<$ARGV[0]"; @_=<RC>; close RC;

$_=join "", grep /<body/, @_;
/text="#(.*?)"/; $textcolor=getcolor($1);
/bgcolor="#(.*?)"/; 
print "\\colorbox{".getcolor($1)."}{
\\begin{minipage}{\\textwidth}
\\ttfamily
";

my %hc;
my $colorcnt=0;

for (@_){
next if /<title/;
s/\\/\\textbackslash /g;
s/&quot;/"/g; s/&gt;/>/g;s/&lt;/</g; s/&amp;/\\&/g; s/&nbsp;/\\ /g; 
s/[\#\$\%\&\~\_\{\}]/\\$&/g;
s/\^/\\^{}/g;

s|/font>(.+?)<|/font>\\color{$textcolor}$1<|g;
s|<font color="\\#(.*?)">(.*?)</font>|"\\color{".getcolor($1)."}$2"|eg;
s"<b>(.*?)</b>"\\textbf{$1}"g;
s/<.*?>//g;
next if /^$/;
#s/\\color.mycolo.*?}\\color/\\color/g;
s/$/\n/g;
print;

}
print "\\end{minipage}}\n";
print "
% add below lines before document.
%\\usepackage{xcolor}
";
for (keys %hc){
print "%\\definecolor{".$hc{$_}."}{HTML}{$_}\n";
}

sub getcolor{
my $htmlcolor=uc(shift);
if(! $hc{$htmlcolor}){
$hc{$htmlcolor}="mycolor$cnt";
$cnt++;
}
return $hc{$htmlcolor};
}

