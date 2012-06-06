#!/usr/bin/perl

#----------define here-----------
$ext="svg"; $sep='///'; $font='Vera Sans YuanTi';
@color=qw(#6495ED #eecc80 #ccee80 #80ccee #eecc80 #80eecc);
$send='[shape=ellipse]'.$end; $dend='[shape=diamond]'.$end;
#--------------------------------
if(($#ARGV==-1) || ($ARGV[0]=~/--help|-h/i) || ! -f "$ARGV[0]"){
print <<HELP;
AUTHOR:		eexpress
VERSION:	1.2
USAGE:		flow.pl source_file
DESCRIPTION:
自动根据注释里面的///后面的内容，生成流程图。依赖graphviz。
flow.pl 文件【各类语法的源码，只要注释不和///冲突】
语法说明：
	xxx> 表示函数入口。通常是函数名。必须有一个。
	>xxx 表示函数出口或者跳转。通常是return或者else/break/next/continue等强制分支。
	xxx?yyy:zzz 条件判断语句。yyy为真，zzz为假。可省略其一。如：xxx?yyy 或者 xxx?:zzz。yyy/zzz 均认为是跳转，不需要写>前缀。
HELP
exit 0;
}
#--------------------------------
$cnt=@color; $cc=0; $end=";\n"; $out=""; @isdia=[];
open IN,"<$ARGV[0]"; @_=<IN>; close IN;
$base=$ARGV[0];$base=~s/\..*//;
@v=map {s".*\Q$sep\E"";s/^\s*//;s/\s*$//;chomp $_;$_} grep /$sep/,@_;
#--------------------------------
for $j (0 .. $#v){
	$i=$v[$j];
	next if $i eq "";
	$i=~s/[\ -\.]/_/g;
	if($i=~/>$/){ #入口
		$out=~s/->$//g; push @output,$out.$end if $out=~/->/;
		push @output,"}\n" if $cc;
		push @output, "\nsubgraph{\t".'node [color="'.($color[$cc%$cnt]).'"]'.$end; $cc++;
		@hasshape=[];
		$i=~s/>//g; setshape($i,$send);
		$out="$i->"; next;
		}
	if($i=~/^>/){ #出口
		$i=~s/^>//; setshape($i,$send);
		push @output,$out.$i.$end if $out=~/->/;
		$out='';
		next;
		}
	if ($i!~/\?/){ #常规
		$out.="$i->"; next;
		}
	# 条件判断，包括出口
	@t=[];@t=split /[?:]/,$i;
	push @output,$out.$t[0].$end if $out=~/->/;
	$out="";
	setshape($t[0],$dend); push @isdia,$t[0];
	jump($t[1],"y"); jump($t[2],"n");
}
#--------------------------------
for(@output){ # 判断的入口，全部顶部
	$i=$_; for(@isdia){$i=~s/->$_/->$_:n/;} $_=$i;}
$out=~s/->$//g; push @output,$out.$end if $out=~/->/;
#--------------------------------
unshift @output,"
digraph G {
node [peripheries=2 shape=box style=filled fontname=$font] label=\"$ARGV[0]\"
";
push @output,"}\n}\n";
open OUT,">$base.dot"; print OUT @output;close OUT;
`dot -T$ext "$base.dot" -o $base.$ext`;
`eog $base.$ext`;
#--------------------------------
sub jump(){
	my ($_, $YN)=@_;
	if($_ eq ""){$_=$v[$j+1]; s/\?.*//;} #为空，分支到下一句
	s/^>//; #判断分支，都是返回，不管出口标志
	if($YN eq "y"){push @output,"$t[0]:s->$_".'[label="Yes"];'."\n";}
	else{push @output,"$t[0]:e->$_".'[label="No" style=dotted];'."\n";}
}
#--------------------------------
sub setshape(){ # 名称，形状
	my ($name, $shape)=@_;
	my $has=grep /^\Q$name\E$/,@hasshape;
	if($has==0){push @hasshape,$name, push @output,"\t".$name.$shape.$end;}
}
#--------------------------------
