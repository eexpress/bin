#!/usr/bin/perl

use 5.10.0;
#~ 可放入nautilus脚本目录，`~/.local/share/nautilus/scripts`。
#~ nautilus会直接给此脚本加参数，但是参数无路径。只能解析 `$ENV{}`。

use Getopt::Long;
GetOptions('horizontal_only'=>\$horizontal_only,'vertical_only'=>\$vertical_only);

sub end{
	`notify-send "要2个及以上图片，才能拼接。"`;
	die "需要2个及以上图片，才能拼接。

使用说明：
参数 -h 指定纯水平拼接；-v 指定纯垂直拼接。
无参数，自动判断拼接成最大尺寸的组合图。
" ;
}

@_ = split '\n', $ENV{'NAUTILUS_SCRIPT_SELECTED_FILE_PATHS'};
#~ @_ //= @ARGV;	# 可惜 Defined-or 操作不能用于数组。
if (scalar @_ > 1){
		$fl = join(' ',map {qq/"$_"/} @_);
} elsif (scalar @ARGV > 1){
	$fl = join(' ',map {qq/"$_"/} @ARGV);
}else{ end; }

#~ `notify-send "debug: $fl"`;
@filelist = `identify -format "%w,%h,%d,%f\n" $fl`;
#~ map {s/(\d{2,})\ /sprintf("%05d\ ", $1)/eg} @filelist;
@filelist = sort @filelist;
say @filelist;
$filenum = scalar @filelist;
end if $filenum < 2;

$suffix = 0;
if($horizontal_only){ horizon_join(1,1); exit; }
if($vertical_only){ horizon_join(0,1); exit; }

my $X0 = int(sqrt($filenum));
my $X1 = $X0+1;
#~ 列数 = 文件数开平方，取整；+0的平方，+1的平方，看离哪个平方最近。
if($X1**2-$filenum > $filenum-$X0**2){$column = $X0;}
else{$column = $X1;}
#~ 最宽不参与排序的个数 = $#取模列数
$dropout = $filenum % $column;
say "文件数 = $filenum，列数 = $column，最宽不参与排序的个数 = $dropout";

while (glob("/tmp/w-*.png")) {
	next if -d; unlink $_ or ++$errors, warn("Can't delete $_: $!");
}

if($dropout){
	@currentlist = ();
	while ($dropout>0){push @currentlist, pop @filelist; $dropout--;}
	horizon_join(1,0);
}

$ispop = 1;
while (@filelist){
	@currentlist = ();
	#~ for($i=0; $i<$column; $i++){
	for(1 .. $column){
		if($ispop){
			push @currentlist, pop @filelist;
			$ispop = 0;
		}else{
			push @currentlist, shift @filelist;
			$ispop = 1;
		}
	}
	horizon_join(1,0);
}

horizon_join(0,0);

sub horizon_join(){
	my $is_horizon = $_[0];
	my $finish_all = $_[1];
	@currentlist = @filelist if $finish_all;
	say "-------";
	if($is_horizon){
		$convert_prefix = "/tmp/h-";
		$sign = "x";
		$montage_prefix = $finish_all? "/tmp/montage-" : "/tmp/w-";
	}else{
		if(!$finish_all){
			say "============";
			$convert_prefix = "/tmp/w-";
			@currentlist = `identify -format "%w,%h,%d,%f\n" $convert_prefix*.png`;
		}
		$convert_prefix = "/tmp/v-";
		$sign = "";
		$montage_prefix = "/tmp/montage-";
	}
	while (glob("$convert_prefix*.png")) {
		next if -d; unlink $_ or ++$errors, warn("Can't remove $_: $!");
	}
#~ identify的%d为当前目录时，输出''，导致附加了一个'/'，导致路径判断出错。
	say @currentlist;
	$min = 10000;
	for my $i (0 .. $#currentlist){	# $#array 是最大标量，比数组长度少1。
		my @r0 = split ',', @currentlist[$i];
		my $h0 = @r0[$is_horizon ? 1 : 0];
		if(@r0[2] == ''){
			@currentlist[$i] = @r0[3];
		} else {
			@currentlist[$i] = @r0[2]+"/"+@r0[3];
		}
		chomp @currentlist[$i];
		$min = $h0 > $min? $min : $h0;
	}
	if($is_horizon){
		say "本组最小高度：$min，按最小高度水平拼接。";
	}
	else{
		say "全部最小宽度：$min，按最小宽度垂直拼接。";
		my $increment = 0;
		while(-e "$montage_prefix$increment.png"){$increment++;}
		$suffix = $increment;
	}
	my $increment = 0;
	while(@currentlist){
		$_ = shift @currentlist;
		$cmd = "convert -scale $sign$min \"$_\" $convert_prefix$increment.png";
		say $cmd;
		`$cmd`;
		$increment++;
	}
	$cmd = "montage -tile ${sign}1 -geometry +0+0 -background none $convert_prefix*.png $montage_prefix$suffix.png";
	say $cmd;
	`$cmd`;
	if($finish_all || !$is_horizon){
		my $increment = 0;
		while(-e "$ENV{'HOME'}/montage-$increment.png"){$increment++;}
		`cp $montage_prefix$suffix.png "$ENV{'HOME'}/montage-$increment.png"`;
		`eog "$ENV{'HOME'}/montage-$increment.png"`;
		return;
	}
	if($is_horizon){$suffix++;}
}

