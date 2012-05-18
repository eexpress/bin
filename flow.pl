#!/usr/bin/perl

open IN,"<$ARGV[0]"; @_=<IN>; close IN;
$base=$ARGV[0];$base=~s/\..*//;
$ext="svg"; $sep='///'; $font='Vera Sans YuanTi'; $color="#6495ED";
$next="_xxx_"; $ends='[shape=ellipse];'."\n";
$out=""; @isdia=[];
#--------------------------------
@v=map {s".*\Q$sep\E"";s/^\s*//;s/\s*$//;chomp $_;$_} grep /$sep/,@_;
for $x (@v){
	push @output, "\t$x".$ends if ! $out;
	if ($x!~/\?/){ 
		for(@output){s/\Q$next\E/$x/;}
		$out.="$x->";
		next;
		}
	# 条件判断
	@t=[];@t=split /[?:]/,$x;
	for(@output){s/\Q$next\E/$t[0]/;}
	$out=~s/^\s*//,push @output,"$out$t[0];\n" if $out=~/->/;
	push @output,"\t$t[0]".'[shape=diamond];'."\n"; push @isdia,$t[0];

	$_=$t[1];
	if(/^>/){s/^>//; push @output,"\t$_".$ends;} #返回，设置形状，不继续节点
	else{if($_ ne ""){push @output,"$_->$next;\n";}else{$_=$next;}}
	push @output,"$t[0]:s->$_".'[label="Yes"];'."\n";

	$_=$t[2];
	if(/^>/){s/^>//; push @output,"\t$_".$ends;} #返回，设置形状，不继续节点
	else{if($_ ne ""){push @output,"$_->$next;\n";}else{$_=$next;}}
	push @output,"$t[0]:e->$_".'[label="No" style=dotted];'."\n";

	$out=" ";
	}

for(@output){ # 判断的入口，全部顶部
	$x=$_; for(@isdia){$x=~s/->$_/->$_:n/;} $_=$x;}

$out=~s/^\s*//;$out=~s/->$/;\n/;
push @output,$out;
#--------------------------------
unshift @output,"
digraph G {
node [peripheries=2 color=\"$color\" shape=box style=filled fontname=$font]
";
push @output,"}\n";
open OUT,">$base.dot"; print OUT @output;close OUT;
`dot -T$ext "$base.dot" -o $base.$ext`;
`eog $base.$ext`;
