#!/usr/bin/perl

use utf8;
use Encode qw/_utf8_on decode/;
use Encode::Guess;
#--------------------------------
$ext="svg"; $sep='/'; $font='Vera Sans YuanTi';
@color=qw(#eecc80 #6495ED #ccee80 #80ccee #eecc80 #80eecc);
$cnt=@color; $cc=0; $end=";\n"; $out=""; @isdia=[];
$quitstr="退出";
$FUNC='[shape=ellipse]'.$end; $JUDGE='[shape=diamond]'.$end;
$QUIT='[shape=egg]'.$end; $EXIT='[shape=house]'.$end;
#http://www.graphviz.org/content/node-shapes

$base=$ARGV[0]; $base=~s/.\K\.[^.]*//;
#$base=$ARGV[0]; $base=~s/(.+)\.[^.]*/\1/;
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
	函数入口：用 >xxx 表示。通常是函数名。第一行缺省为入口。
	条件判断：用 xxx?yyy:zzz 表示，yyy/zzz为跳转的行号，使用0表示退出。yyy为真，zzz为假。可省略其一，如：xxx?yyy 或者 xxx?:zzz。省略的直接接下一句；都不省略的短语，2个条件都接下一句。
	普通行：可以使用;连接多句。判断行和函数入口不能带多句。
HELP
exit 0;
}
#--------------------------------
open IN,"<$ARGV[0]"; while(<IN>){
	next if ! /$sep{3}/;
	s/.*$sep{3}\s*//; s/\s*$//;	#去掉首尾空格
	my $enc = guess_encoding($_, qw/utf8 cp936 gbk/);
	if (ref($enc)){$_=decode($enc->name, $_);}
	_utf8_on($_);
	push @contents, "$. $_"; }
close IN;
#for(@contents){print "$_\n";} exit;
#--------------------------------
for $j (0 .. $#contents){
	$contents[$j]=~/ /; $line=$`; $_=$';
	if(/^>/ || ! $j){	#入口。带>或者第一行。
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
	$judge=makeup($judge); saveout($judge);
	setshape($judge,$JUDGE); push @isdia,$judge;

#    下句的第一个段。下一个是入口或者数据完，都退出。
	$_=$contents[$j+1];
	my $next=(/\d+\ >/ || $_ eq "")?$q:fetch01seg($_);

	if($byes ne ""){
		$goto=normal_segment($byes);
	}else{ $goto=$next; }
	push @output,"$judge:s->$goto".'[label="Yes"];'."\n";
	if($bno ne ""){
		$goto=normal_segment($bno);
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
bgcolor=transparent
node [peripheries=2 shape=box style=\"rounded,filled\" fontname=\"$font\"] label=\"$ARGV[0]\"
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
#            $_.="_$line"; $_="\"$_\"" if /[-= ><.]/;
			$out.= makeup($_)."->"; next;}
		if($_ eq "0"){
#            push @output,$out.$q.$end if $out=~/->/;
#            $out='';
			return $q;
		}else{
			$d=0; $d=$_;
			for $sline (@contents){
				$_=$sline; s/\ .*//;
				if($d>$_){next;}
				$_=fetch01seg($sline);
#            print "fetch....$_....\n";
#                saveout($_);
				return $_;
			}
		}
		break;
	}
}
#--------------------------------
sub saveout(){
# 缓存内容附加输入的内容，判断有效后保存。
	my $i=shift;
	if($i){$out.=$i;}else{$out=~s/->$//;}
	push @output,$out.$end if $out=~/->/;
	$out="";
}
#--------------------------------
sub fetch01seg(){
# 正常行，取第一个字段，组合行号
	$_=shift;
	s/[?;].*//; /\ /;
	if($' eq "0"){return $q;}
	$_=$'."_$`"; $_="\"$_\"" if /[-= ><.*]/;
	return $_;
}
#--------------------------------
sub makeup(){
# 内容直接和当前行号组合
	$_=shift; $_.="_$line"; $_="\"$_\"" if /[-= ><.*]/;
	return $_;
}
#--------------------------------
