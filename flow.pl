#!/usr/bin/perl

open IN,"<$ARGV[0]"; @_=<IN>; close IN;
$base=$ARGV[0];$base=~s/\..*//;
$ext="svg"; $sep='///'; $font='Vera Sans YuanTi'; $color="#6495ED";
$next="_xxx_"; $end=";\n";
$send='[shape=ellipse]'.$end;
$dend='[shape=diamond]'.$end;
$out=""; @isdia=[];
@v=map {s".*\Q$sep\E"";s/^\s*//;s/\s*$//;chomp $_;$_} grep /$sep/,@_;
#--------------------------------
for $i (@v){
	next if $i eq "";
	if($i=~/>$/){ #入口
		$i=~s/>//g; push @output, "\t".$i.$send;
		push @output,$out.$end if $out=~/->/ && $out!~/->$/;
		$needreplace=0; $out="$i->"; next;
		}
	if ($i!~/\?/){  #常规
		$i=~s/>//g;
		if($needreplace){for(@output){s/\Q$next\E/$i/;}};
		$needreplace=0; $out.="$i->";
#print $out."--------$i---\n";
		next;
		}
	# 条件判断
	@t=[];@t=split /[?:]/,$i;
	if($needreplace){for(@output){s/\Q$next\E/$t[0]/;}};
	push @output,$out.$t[0].$end if $out=~/->/;
	$out="";
	push @output,"\t".$t[0].$dend; push @isdia,$t[0];

	$_=$t[1];
	if(/^>/){s/^>//; push @output,"\t$_".$send;} #返回，设置形状，不继续节点
	else{if($_ ne ""){push @output,"$_->$next;\n";}else{$_=$next;}}
	push @output,"$t[0]:s->$_".'[label="Yes"];'."\n";

	$_=$t[2];
	if(/^>/){s/^>//; push @output,"\t$_".$send;} #返回，设置形状，不继续节点
	else{if($_ ne ""){push @output,"$_->$next;\n";}else{$_=$next;}}
	push @output,"$t[0]:e->$_".'[label="No" style=dotted];'."\n";

	$needreplace=1;
	}
#--------------------------------
for(@output){ # 判断的入口，全部顶部
	$i=$_; for(@isdia){$i=~s/->$_/->$_:n/;} $_=$i;}
#$out=~s/^\s*//;$out=~s/->$/;\n/; push @output,$out;
#--------------------------------
unshift @output,"
digraph G {
node [peripheries=2 color=\"$color\" shape=box style=filled fontname=$font]
";
push @output,"}\n";
open OUT,">$base.dot"; print OUT @output;close OUT;
`dot -T$ext "$base.dot" -o $base.$ext`;
`eog $base.$ext`;
