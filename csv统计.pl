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
# 过滤”2015-01-21 15:20:42 “这种格式。
				next if ! /\d/; s/\ .*//;$d=$_,next if /\d+-\d+-\d+/;
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
# 统计重复，直接使用背景色标记年/月的统计。
#        $total+=$hash{$_};
		print "\e[42m" if /M/;
		print "\e[41m" if /Y/;
		printf "%-16s->%14.2f",$_,$hash{$_};
		print "\e[0m" if /[MY]/;
		print "\n";
	}
}
print (("-"x32)."\n");
#print "total:\t\t\t$total\n";

