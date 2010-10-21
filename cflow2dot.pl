#!/usr/bin/perl

if(! -x "/usr/bin/cflow"){print "\'cflow\' not installed.\n"; exit;}
$in=join " ",@ARGV;
my @index;
my @output;
my @color=qw(#eecc80 #ccee80 #80ccee #eecc80 #80eecc);
my @shape=qw(box ellipse octagon hexagon diamond);
my $tmpdot="/tmp/cflow.dot";
my $ext="svg";
my $tmppng="/tmp/cflow.$ext";

foreach (`/usr/bin/cflow -d 2 $in`){
	chomp;
	s/^ *//; my $n=length($&)/4;
	my $isnode=m/:$/?1:0;
	s/\(.*$//;
	$index[$n]=$_ if($isnode);
#        print "n=$n\tisnode=$isnode\t$index[$n-1]->$_;\n";
	if($n){
	push @output,"node [color=\"$color[$n-1]\" shape=$shape[$n]];edge [color=\"$color[$n-1]\"];\n";
	push @output,"$index[$n-1]->$_;\n";}
	else{push @output,"$_ [shape=box];\n";}
}
unshift @output,"node [peripheries=2 style=\"filled,rounded\" fontname=\"Vera Sans YuanTi Mono\" color=\"$color[0]\"];\nrankdir=LR;\nlabel=\"$in\"\n";
unshift @output,"\n";
unshift @output,"digraph G {\n";
push @output,"}\n";

print "dot output to $tmpdot.\n";
#my @unique=grep {! $count{$_}++ || ! /->/ } @output;
#$count = 1;
#for (@unique) {
#if( /^node/ && $unique[$count]=~/^node/){$_="";}
#$count++;
#}
@unique=@output;
open FILE,'>',$tmpdot; print FILE @unique;close FILE;

if(-x "/usr/bin/dot"){
`dot -T$ext $tmpdot -o $tmppng`;
print "$ext output to $tmppng.\n";
if(-x "/usr/bin/eog"){`eog $tmppng`;}
}
else{print "\'dot(graphviz)\' not installed.\n"}
