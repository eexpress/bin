#!/usr/bin/perl

use 5.10.0;
#~ 可放入nautilus脚本目录，`~/.local/share/nautilus/scripts`。
#~ nautilus会直接给此脚本加参数，但是参数无路径。只能解析 `$ENV{}`。

sub end{
	`notify-send "要2个及以上图片，才能拼接。"`;
	die "需要2个及以上图片，才能拼接。" ;
}

@_ = split '\n', $ENV{'NAUTILUS_SCRIPT_SELECTED_FILE_PATHS'};
#~ @_ //= @ARGV;	# 可惜 Defined-or 操作不能用于数组。
if (scalar @_ > 1){
		$f = join(' ',map {qq/"$_"/} @_);
} elsif (scalar @ARGV > 1){
	$f = join(' ',map {qq/"$_"/} @ARGV);
}else{ end; }

#~ `notify-send "debug: $f"`;
@r = `identify -format "%w %h %d/%f\n" $f`;
map {s/(\d{2,})\ /sprintf("%05d\ ", $1)/eg} @r;
@r = sort @r;
say @r;
$filenum = scalar @r;
end if $filenum < 2;

my $x = int(sqrt($filenum));
my $y = $x+1;
#~ 列数 = 文件数开平方，取整；+0的平方，+1的平方，看离哪个平方最近。
if($y**2-$filenum > $filenum-$x**2){$column = $x;}else{$column = $y;}
#~ 最宽不参与排序的个数 = $#取模列数
$dropout = $filenum % $column;
say "文件数 = $filenum，列数 = $column，最宽不参与排序的个数 = $dropout";

while (glob("/tmp/w-*.png")) {
	next if -d; unlink $_ or ++$errors, warn("Can't remove $_: $!");
}

if($dropout){
	@h = ();
	while ($dropout>0){push @h, pop @r; $dropout--;}
	horizon_join(1);
}

$suffix_w = 0;
$pop = 1;
while (@r){
	@h = ();
	#~ for($i=0; $i<$column; $i++){
	for(1 .. $column){
		if($pop){
			push @h, pop @r;
			$pop = 0;
		}else{
			push @h, shift @r;
			$pop = 1;
		}
	}
	horizon_join(1);
}

horizon_join(0);

sub horizon_join(){
	$is_horizon = $_[0];
	say "-------";
	if($is_horizon){
		$f = "/tmp/h-";
	}else{
		$f = "/tmp/w-";
		@h = `identify -format "---- %w %d/%f\n" $f*.png`;
		$f = "/tmp/v-";
	}
	while (glob("$f*")) {
		next if -d; unlink $_ or ++$errors, warn("Can't remove $_: $!");
	}
	say @h;
	$min = 10000;
	for my $i (0 .. $#h){	# $#h 是最大标量，比数组长度少1。
		@r0 = split ' ', @h[$i];
		$h1 = @r0[1];
		@h[$i] = @r0[2];
		$min = $h1 > $min? $min : $h1;
	}
	if($is_horizon){
		say "本组最小高度：$min，按最小高度水平拼接。";
		$p = "x";
		$o = "w";
	}
	else{
		say "全部最小宽度：$min，按最小宽度垂直拼接。";
		$p = "";
		$o = "montage";
		$suffix_m = 0;
		while(-e "/tmp/$o-$suffix_m.png"){$suffix_m++;}
		$suffix_w = $suffix_m;
	}
	$suffix = 0;
	while(@h){
		$_ = shift @h;
		$cmd = "convert -scale $p$min \"$_\" $f$suffix.png";
		say $cmd;
		`$cmd`;
		$suffix++;
	}
	$cmd = "montage -tile ${p}1 -geometry +0+0 -background none $f*.png /tmp/$o-$suffix_w.png";
	say $cmd;
	`$cmd`;
	if($is_horizon){$suffix_w++;}
	else{`eog /tmp/$o-$suffix_w.png`;}

}

