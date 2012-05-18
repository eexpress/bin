#!/usr/bin/perl

open IN,"<$ARGV[0]"; @_=<IN>; close IN;
$base=$ARGV[0];$base=~s/\..*//;
$ext="svg"; $sep='///'; $font='Vera Sans YuanTi'; $color="#6495ED";
#--------------------------------
@v=map {s".*\Q$sep\E"";s/^\s*//;s/\s*$//;chomp $_;$_} grep /$sep/,@_;
$out="";
for(@v){
push @output, "$_".'[shape=ellipse];'."\n" if ! $out;
$out.="$_->",next if ! /\?/;
@t=split /[?:]/,$_;
push @output,"$t[0]".'[shape=diamond]';
push @output,"$out$t[0];\n";
push @output,"$t[0]:s->$t[1]".'[label="Yes"];'."\n";
push @output,"$t[0]:e->$t[2]".'[label="No" style=dotted];'."\n";
$out=" ";
}
$out=~s/->$/;\n/;
push @output,$out;
for(@output){print $_;}
#--------------------------------
unshift @output,"
digraph G {
node [peripheries=2 color=\"$color\" shape=box style=filled fontname=$font]
";
push @output,'}\n';

open OUT,">$base.dot"; print OUT @output;close OUT;
`dot -T$ext "$base.dot" -o $base.$ext`;
`eog $base.$ext`;
