#!/usr/bin/perl

@_=`xsel -o`;
foreach (@_){
	if(/^20\d\d-\d/){$date=$_;}
	elsif(/^#/){$tag=$_;}
	else{
		if(/^图片$/){push @text,"![](/img/)\n";}
		else{
			push @text,$_ if /\S/;
		}
	}
}
$title=$text[0];
chomp $title;
chomp $date;
$file=$title;
$file=~s/\ /-/g;
$file=~s/\//-/g;
$file.=".md";
print "title: $title\n";
#print "file: $file\n";
#print "date: $date\n";
#print "text:\n";
#print "@text";
#print "tags: $tag\n";
#exit;
$tag=~s/\ #/#/g;
@t=split /#/,$tag;
delete $text[0];

open OUT,">$file";
print OUT "title: $title\n";
print OUT "date: $date\n";
print OUT "tags:\n";
foreach (@t){
	print OUT "- $_\n" if /\S/;
}
print OUT "---\n";
foreach(@text){print OUT $_;}
#print OUT "@text\n";
close OUT;
#print "--------";
#print @text;
#print "--------";
`/usr/bin/gvim --remote-silent-tab $file`;
