#!/usr/bin/perl

#--------------------------------
$ext="svg"; $sep='/'; $font='Vera Sans YuanTi';
@color=qw(#eecc80 #6495ED #ccee80 #80ccee #eecc80 #80eecc);
$cnt=@color; $cc=0; $end=";\n"; $out=""; @isdia=[];
$quitstr="退出";
$FUNC='[shape=ellipse]'.$end; $JUDGE='[shape=diamond]'.$end;
$QUIT='[shape=egg]'.$end; $EXIT='[shape=house]'.$end;
#http://www.graphviz.org/content/node-shapes

$base=$ARGV[0];$base=~s/\..*//;
#--------------------------------
if(($#ARGV==-1) || ($ARGV[0]=~/--help|-h/i) || ! -f "$ARGV[0]"){
print <<HELP;
AUTHOR:		eexpress
VERSION:	1.6
USAGE:		flow.pl source_file
DESCRIPTION:
自动根据注释里面的///后面的内容，生成流程图。依赖graphviz。
flow.pl 文件【各类语法的源码，只要注释不和///冲突】
语法说明：
	>xxx 表示函数入口。通常是函数名。第一行缺省为入口。不能带;
	xxx?yyy:zzz 条件判断语句。yyy为真，zzz为假。可省略其一，如：xxx?yyy 或者 xxx?:zzz。省略的直接接下一句；都不省略的短语，2个条件都接下一句。
	跳转到某行使用数字表示。比如 xxx?23。使用0表示退出/return/exit。
	使用;连接多句。
HELP
exit 0;
}
#--------------------------------
open IN,"<$ARGV[0]"; while(<IN>){
	next if ! /$sep{3}/;
	s/.*$sep{3}\s*//; s/\s*$//;	#去掉首尾空格
#    s/;/_$.->/g; push @contents, $_."_$."; }
	push @contents, "$. $_"; }
close IN;
#for(@contents){print "$_\n";} exit;
#--------------------------------
for $j (0 .. $#contents){
	$contents[$j]=~/ /; $line=$`; $_=$';
	if(/^>/ || ! $j){	#入口。带>或者第一行。不能带;号。
		if($j){
		saveout($q); setshape($q,$EXIT);
		push @output,"}\n";	#结束subgraph
		}
		push @output, "\nsubgraph{\t".'node [color="'.($color[$cc%$cnt]).'"]'.$end; $cc++;
		$q=$quitstr."_$cc";
		s/^>//g; normal_segment($_);
			$_.="_$line"; $_="\"$_\"" if /[- .]/;
		setshape($_,$FUNC); next;
	}
	if (! /\?/){ normal_segment($_); next;}
#--------------------------------
	# 条件判断
	($judge,$byes,$bno)=split /[?:]/;
#    $judge.="_$line"; $_=$judge; $_="\"$_\"" if /[- .]/;
#    $out.=$_; saveout();
	$judge=makeup($judge); saveout($judge);
	setshape($judge,$JUDGE); push @isdia,$judge;

#    下句的第一个段
#    $_=$contents[$j+1]; s/[;?].*//; /\ /;
#    $_=$'."_$`"; $_="\"$_\"" if /[- .]/;

	$_=$contents[$j+1];
#    if(/\d+\ >/ || $_ eq ""){return $q;}
#下一个入口/数据完，都退出。
	my $next=(/\d+\ >/ || $_ eq "")?$q:fetch01seg($_);

	if($byes ne ""){
		$goto=fetch01seg("$line $byes");
		normal_segment($byes); if($bno){ saveout($next); }
	}else{ $goto=$next; }
	push @output,"$judge:s->$goto".'[label="Yes"];'."\n";
	if($bno ne ""){
		$goto=fetch01seg("$line $bno");
		normal_segment($bno);
	}else{ $goto=$next; }
	push @output,"$judge:e->$goto".'[label="No" style=dotted];'."\n";
}
#--------------------------------
for(@output){ # 判断的入口，全部顶部
	$in=$_; for(@isdia){$in=~s/->$_/->$_:n/;} $_=$in;
	s/>>/>/;
}
saveout($q); setshape($q,$EXIT);
#--------------------------------
unshift @output,"
digraph G {
node [peripheries=2 shape=box style=\"rounded,filled\" fontname=$font] label=\"$ARGV[0]\"
";
push @output,"}\n}\n";
open OUT,">$base.dot"; print OUT @output;close OUT;
`dot -T$ext "$base.dot" -o $base.dot.$ext`;
`eog $base.dot.$ext`;
#--------------------------------
sub setshape(){ # 名称，形状
	my ($name, $shape)=@_;
	my $has=grep /^\Q$name\E$/,@shapegroup;
	if($has==0){push @shapegroup,$name; push @output,"\t".$name.$shape;}
}
#--------------------------------
sub normal_segment(){
#    假设$out有数据
	my @seg=split /;/, shift;
	for(@seg){
		if(/\D/){	#非跳转。附加行号，遇特殊字符，引号包括。
			$_.="_$line"; $_="\"$_\"" if /[- .]/;
			$out.="$_->"; next;}
		if($_ eq "0"){
			push @output,$out.$q.$end if $out=~/->/;
			$out='';
		}else{
			$d=0; $d=$_;
			for $line (@contents){
				$_=$line; s/\ .*//;
				if($d>$_){next;}
				$_=fetch01seg($line);
#            print "fetch....$_....\n";
				saveout($_);
				return;
			}
		}
		break;
	}
}
#--------------------------------
sub saveout(){
	my $i=shift;
	if($i){$out.=$i;}else{$out=~s/->$//;}
	push @output,$out.$end if $out=~/->/;
	$out="";
}
#--------------------------------
sub fetch01seg(){
	$_=shift;
	s/[?;].*//; /\ /;
	if($' eq "0"){return $q;}
	$_=$'."_$`"; $_="\"$_\"" if /[- .]/;
	return $_;
}
#--------------------------------
sub makeup(){
	$_=shift; $_.="_$line"; $_="\"$_\"" if /[- .]/;
	return $_;
}
#--------------------------------
