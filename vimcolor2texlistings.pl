#!/usr/bin/perl

$_=$ARGV[0];
die "not vim color file" if ! /\.vim$/;
@_=`egrep -i 'background|identifier|comment|key|constant' $_`;
$_=join "", grep /background/, @_;
/background=(.*)/;
print "%$1\n";
$_=`grep $1 /etc/X11/rgb.txt`;
print;

%hc=("identifier"=>"identifierstyle","comment"=>"commentstyle",
"key"=>"keywordstyle,emphstyle", 
"constant"=>"commentstyle,stringstyle,numberstyle"
);
#print @_;
for (keys %hc){
$_=join "", grep /$i/i, @_;
/guifg=(.*)/;
print "%$i: ..$_..\t..$1..\n";
if($1=~/^#/){print $i."style=\color[HTML]{".uc($1)."}\n";}
else{
	$_=`grep "\<$1\>" /etc/X11/rgb.txt`;
	/[0-9\ ]+/; $_=$&; s/\ /,/g;
	print $i."style=\color[RGB]{".$_."}\n";
}
#print $i;
}

