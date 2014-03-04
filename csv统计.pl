#!/usr/bin/perl

#从逗号分割的csv获取日期格式和金额2个段，统计月/年费用。参数为混合csv文件和搜索条件。最后一个非csv参数为搜索条件。hash保存的3种格式，方便搜索。
#2014-01-30	->	494.5
#2014-01M	->	1803.1
#2014Y		->	1803.1
$select='Y';
foreach(@ARGV){
	if (/\.csv$/){
		open IN,"<$_"; while(<IN>){
			next if ! /-.*-/;	#跳过无日期的行
			s/"//g;				#过滤掉引号
			@seg=split /,/;
			$d=""; $m="";
			foreach(@seg){
				next if ! /\d/; $d=$_,next if /\d+-\d+-\d+/;
				$m=$_,next if /^[\d\.]+$/ && ! /\d{7,}/;	#全数字或者带小数点的
			}
			next if $d eq "";
			$hash{$d}+=$m;
			$d=~s/-\d+$//;
			$hash{$d."M"}+=$m;
			$d=~s/-\d+$//;
			$hash{$d."Y"}+=$m;
		}
	} else {$select=$_;}
}
foreach(sort keys %hash){
#    $total+=$hash{$_},print "$_\t->\t$hash{$_}\n" if /$select/;
	if(/$select/){
		/^..../;$c=$&;
		if($c!=$d){print (("-"x32)."\n");$d=$c;}
		$total+=$hash{$_};printf "%-16s->%14.2f\n",$_,$hash{$_};
	}
}
print (("-"x32)."\n");
print "total:\t\t\t$total\n";

