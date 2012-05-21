#!/usr/bin/perl

if(($#ARGV==-1) || ($ARGV[0]=~/--help|-h/i) || ! -f "$ARGV[0]"){
print <<HELP;
自动根据注释里面的///后面的内容，生成流程图。依赖graphviz。
flow.pl 文件【各类语法的源码，只要注释不和///冲突】
语法说明：
	xxx> 表示函数入口。通常是函数名。
	>xxx 表示函数出口。通常是return。
	xxx?yyy:zzz 条件判断语句。yyy为真，zzz为假。可省略其一。如：xxx?yyy 或者 xxx?:zzz。
	循环体，如while if等，写成条件判断的时候，:后面的假分支，如果指向return返回语句，必须也加上>的前缀。
HELP
exit 0;
}

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
$out=~s/^\s*//;$out=~s/->$//g; push @output,$out.$end;
#--------------------------------
unshift @output,"
digraph G {
node [peripheries=2 color=\"$color\" shape=box style=filled fontname=$font] label=\"$ARGV[0]\"
";
push @output,"}\n";
open OUT,">$base.dot"; print OUT @output;close OUT;
`dot -T$ext "$base.dot" -o $base.$ext`;
`eog $base.$ext`;
