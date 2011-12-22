#!/usr/bin/perl

$rgbfile="/usr/share/X11/rgb.txt";
$_=$ARGV[0]//"/usr/share/vim/vim72/colors/desert.vim";
die "not vim color file" if ! /\.vim$/;
open F,"<$rgbfile"; @rgb=<F>; close F;

print "% color schema from file: >$_<
\\usepackage{listings}
\\lstset{
\tnumbers=left,
\tshowstringspaces=false,
\tbreaklines,%这条命令可以让LaTeX自动将长的代码行换行排版
\ttabsize=4,
\tframe=shadowbox,rulecolor=\\color[gray]{0.9},rulesepcolor=\\color[gray]{0.2},
\t%样式
\tbackgroundcolor=\\color[HTML]{333333},
\tbasicstyle=\\ttfamily,
";

%hc=("identif"=>"identifierstyle","comment"=>"commentstyle",
"statement"=>"keywordstyle,emphstyle", 
"constant"=>"stringstyle,numberstyle",
);

my $s=join '|', keys %hc;
@_=`egrep -i '$s' $_`;

for $i (keys %hc){
$_=join "", grep /$i/i, @_;
/guifg=(.*)/o;
my $cn=$1;
my $bf=$i=~/state/?"\\bf":"";
if($cn=~/^#/){$cn=~s/#//g;$out="=$bf\\color[HTML]{".uc($cn)."},\n";}
else{
	$_=join '',grep /\t$cn\n/i, @rgb;
	s/\t.*//;
	$_=join ',', split /\s+/,$_;
	$out="=$bf\\color[RGB]{$_}, %$cn\n";
}
foreach (split /,/,$hc{$i}){print $_.$out;}
}
print "}\n";
