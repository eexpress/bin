#!/usr/bin/perl

@_=`xsel -o`;
foreach (@_){
	if(/^201/){$date=$_;}
	elsif(/^#/){$tag=$_;}
	else{
		s/^\ //;
		if(/图片$/){push @test,"![](/img/)\n";}
		else{
			push @text,$_ if /[\S]/;
		}
	}
}
$title=$text[0];
chomp $title;
chomp $date;
$file=$title;
$file=~s/\ /-/g;
$file.=".md";
print "file: $file\n";
print "date: $date\n";
print "title: $title\n";
print "text:\n";
print "@text";
print "tags: $tag\n";
$tag=~s/\ #/#/g;
@t=split /#/,$tag;

open OUT,">$file";
print OUT "title: $title\n";
print OUT "date: $date\n";
print OUT "tags:\n";
foreach (@t){
	print OUT "- $_\n";
}
print OUT "---\n";
print OUT "@text\n";
close OUT;
`/usr/bin/gvim --remote-silent-tab $file`;
