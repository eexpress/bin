#!/usr/bin/perl
use 5.10.0;
use strict;
use warnings;

use Getopt::Long;
my ($horizontal_only,$vertical_only);
GetOptions('horizontal_only'=>\$horizontal_only,'vertical_only'=>\$vertical_only);

sub end{
	`notify-send "要2个及以上图片，才能拼接。"`;
	die "需要2个及以上图片，才能拼接。
参数 -h 纯水平；-v 纯垂直；无参数自动网格拼接\n";
}

my @filelist_raw;
if(exists $ENV{'NAUTILUS_SCRIPT_SELECTED_FILE_PATHS'} && $ENV{'NAUTILUS_SCRIPT_SELECTED_FILE_PATHS'} ne ''){
	@filelist_raw = split /\n/, $ENV{'NAUTILUS_SCRIPT_SELECTED_FILE_PATHS'};
}elsif(scalar @ARGV > 1){
	@filelist_raw = @ARGV;
}else{
	end;
}

my @valid_files = grep { -f && /\.(png|jpg|jpeg|webp|avif)$/i } @filelist_raw;
end if scalar @valid_files < 2;

my $fl = join(' ',map {qq/"$_"/} @valid_files);

my @filelist = `magick identify -format "%w,%h,%d,%f\n" $fl`;
chomp @filelist;
@filelist = sort grep {length} @filelist;
my $filenum = scalar @filelist;
end if $filenum < 2;

my $suffix = 0;
if($horizontal_only){ horizon_join(1,1,\@filelist); exit; }
if($vertical_only){ horizon_join(0,1,\@filelist); exit; }

my $X0 = int(sqrt($filenum));
my $X1 = $X0+1;
my $column;
if($X1**2-$filenum > $filenum-$X0**2){
	$column = $X0;
}else{
	$column = $X1;
}
my $dropout = $filenum % $column;
say "文件数 = $filenum，列数 = $column，最宽不参与排序的个数 = $dropout";

# 清空临时文件
unlink glob("/tmp/w-*.png");
unlink glob("/tmp/h-*.png");
unlink glob("/tmp/v-*.png");
unlink glob("/tmp/montage-*.png");

# 复制一份原始数组用于分块水平拼接，保留原数组备份
my @work_list = @filelist;

if($dropout){
	my @currentlist = ();
	while ($dropout>0){push @currentlist, pop @work_list; $dropout--;}
	horizon_join(1,0,\@currentlist);
}

my $ispop = 1;
while (@work_list){
	my @currentlist = ();
	for(1 .. $column){
		if($ispop){
			push @currentlist, pop @work_list;
			$ispop = 0;
		}else{
			push @currentlist, shift @work_list;
			$ispop = 1;
		}
	}
	horizon_join(1,0,\@currentlist);
}

# 关键：传入空引用标记全部合并，手动读取w-块，不再依赖work_list
say "===== 开始垂直合并所有水平块 =====";
horizon_join(0,0,[]);

sub horizon_join{
	my ($is_horizon, $finish_all, $ref_list) = @_;
	my @currentlist = @$ref_list;

	if (!$is_horizon && !$finish_all) {
		say "=========== 读取/tmp/w-*.png 水平块 ===========";
		my @tmp_blocks = `magick identify -format "%w,%h,/tmp,%f\n" /tmp/w-*.png 2>/dev/null`;
		chomp @tmp_blocks;
		@currentlist = grep { length } @tmp_blocks;
		say "读取到水平块数量：".scalar(@currentlist);
		return if scalar(@currentlist) == 0;
	}
	return if scalar @currentlist == 0;

	say "-------";
	my ($convert_prefix, $sign, $montage_prefix);
	if($is_horizon){
		$convert_prefix = "/tmp/h-";
		$sign = "x";
		$montage_prefix = $finish_all? "/tmp/montage-" : "/tmp/w-";
	}else{
		$convert_prefix = "/tmp/v-";
		$sign = "";
		$montage_prefix = "/tmp/montage-";
	}

	unlink glob("$convert_prefix*.png");

	my $min = 10000;
	my @file_paths;
	for my $line (@currentlist){
		my ($w,$h,$dir,$fname) = split /,/, $line;
		my $fullpath = "$dir/$fname";
		push @file_paths, $fullpath;
		my $val = $is_horizon ? $h : $w;
		$min = $val if $val < $min;
	}

	if($is_horizon){
		say "本组最小高度：$min，按最小高度水平拼接。";
	}else{
		say "全部最小宽度：$min，按最小宽度垂直拼接。";
		my $increment = 0;
		while(-e "$montage_prefix$increment.png"){$increment++;}
		$suffix = $increment;
	}

	my $increment = 0;
	for my $fp (@file_paths){
		my $cmd = "magick convert -scale $sign$min \"$fp\" $convert_prefix$increment.png";
		say $cmd;
		`$cmd 2>/dev/null`;
		$increment++;
	}

	my $tile_opt = $is_horizon ? "x1" : "1x";
	my $cmd_mont = "magick montage -tile $tile_opt -geometry +0+0 -background none $convert_prefix*.png $montage_prefix$suffix.png";
	say $cmd_mont;
	`$cmd_mont 2>/dev/null`;

	if($finish_all || !$is_horizon){
		my $out_inc = 0;
		while(-e "$ENV{'HOME'}/montage-$out_inc.png"){$out_inc++;}
		my $out_file = "$ENV{'HOME'}/montage-$out_inc.png";
		if (-f "$montage_prefix$suffix.png") {
			`cp "$montage_prefix$suffix.png" "$out_file" 2>/dev/null`;
			say "拼接完成，输出：$out_file";
		}else{
			say "错误：最终拼接文件 $montage_prefix$suffix.png 生成失败";
		}
		if( `which eog 2>/dev/null` ne '' ){
			`eog "$out_file" &`;
		}
		return;
	}
	if($is_horizon){$suffix++;}
}
