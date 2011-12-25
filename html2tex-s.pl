#!/usr/bin/perl

$_=`mimetype $ARGV[0]`;
die "$ARGV[0] is not an html file." if ! m"text/html";
open RC,"<$ARGV[0]"; @_=<RC>; close RC;

$_=join "", grep /<body/, @_;
/bgcolor="#(.*?)"/; print "\\colorbox[HTML]{$1}{\\parbox{\\textwidth}{\n\\ttfamily\n";
/text="#(.*?)"/; $textcolor=uc($1);

for (@_){
next if /<title/;
s/\\/\\textbackslash /g;
s/&quot;/"/g; s/&gt;/>/g;s/&lt;/</g; s/&amp;/\\&/g; s/&nbsp;/\\ /g; 
s/[\#\$\%\&\~\_\{\}]/\\$&/g;
s/\^/\\^{}/g;

#s|/font>(.+?)<|/font>\\color[HTML]{$textcolor}$1<|g;
s|<font color="\\#(.*?)">(.*?)</font>|"\\color[HTML]{".uc($1)."}{$2}\\color[HTML]{$textcolor}"|eg;
s"<b>(.*?)</b>"\\textbf{$1}"g;
s/<.*?>//g;
next if /^$/;
s/\\color\[HTML\]\{[A-F0-9]+\}\s*\\color/\\color/g;
#s/(\\color\[HTML\]\{[A-F0-9]+\})(.*?)\1/$1$2/g;
#s/(\\color\[HTML\]\{[A-F0-9]+\})(.*)\1/$1$2/g;
s/$/\n/g;
print;

}
print "}}";

