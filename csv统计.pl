#!/usr/bin/perl

#从逗号分割的csv获取日期格式和金额2个段，统计月/年费用。参数为混合csv文件和搜索条件。最后一个非csv参数为搜索条件。hash保存的3种格式，方便搜索。
#2014-01-30	->	494.5
#2014-01M	->	1803.1
#2014Y		->	1803.1
foreach(@ARGV){
	if (/\.csv$/){
		open IN,"<$_"; while(<IN>){
			next if ! /-.*-/;	#跳过无日期的行
			s/"//g;				#过滤掉引号
			@seg=split /,/;
			$d=""; $m="";
			foreach(@seg){
				next if ! /\d/; $d=$_,next if /-.*-/;
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
print "---------------------------------\n";
foreach(sort keys %hash){
	$total+=$hash{$_},print "$_\t->\t$hash{$_}\n" if /$select/;
}
print "---------------------------------\n";
print "total:\t\t\t$total\n";

#▶ ./csv统计.pl wacai_\(2010-03~2014-02\).csv 2014.*M toshl_export.csv 
#---------------------------------
#2014-01M	->	11535.8
#2014-02M	->	5554
#---------------------------------
#total:			17089.8
#▶ ./csv统计.pl wacai_\(2010-03~2014-02\).csv M toshl_export.csv 
#---------------------------------
#2010-03M	->	376178.5
#2010-04M	->	54701.8
#2010-05M	->	7118.1
#2010-06M	->	8158.8
#2010-07M	->	13270.7
#2010-08M	->	8013.21
#2010-09M	->	10244.5
#2010-10M	->	23028.8
#2010-11M	->	23192.58
#2010-12M	->	9285.5
#2011-01M	->	25616.5
#2011-02M	->	12840.6
#2011-03M	->	9491.8
#2011-04M	->	13535.1
#2011-05M	->	7170.7
#2011-06M	->	7099.4
#2011-07M	->	8404.1
#2011-08M	->	8182
#2011-09M	->	11738.1
#2011-10M	->	10411.3
#2011-11M	->	6612.6
#2011-12M	->	13111
#2012-01M	->	7482
#2012-02M	->	9933
#2012-03M	->	13705.69
#2012-04M	->	3975.56
#2012-05M	->	15611.9
#2012-06M	->	4059.1
#2012-07M	->	6586.3
#2012-08M	->	4858.3
#2012-09M	->	20712.4
#2012-10M	->	8439.6
#2012-11M	->	10644
#2012-12M	->	2128.86
#2013-01M	->	6167.4
#2013-02M	->	17998.3
#2013-03M	->	10115.1
#2013-04M	->	22508.7
#2013-05M	->	19334.8
#2013-06M	->	6978.3
#2013-07M	->	7167.42
#2013-08M	->	10112.8
#2013-09M	->	7591.3
#2013-10M	->	10544
#2013-11M	->	6776.3
#2013-12M	->	12722.5
#2014-01M	->	11535.8
#2014-02M	->	5554
#---------------------------------
#total:			930649.12

