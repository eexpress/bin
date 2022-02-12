#!/usr/bin/perl

use 5.010;

die "需要2个及以上图片，才能拼接。" if scalar @ARGV < 2;
$f = join(' ',map {qq/"$_"/} @ARGV);
@r = `identify -format "%w %h %d/%f\n" $f`;
map {s/(\d{2,})\ /sprintf("%05d\ ", $1)/eg} @r;
@r = sort @r;
say @r;
$i = scalar @r;
die "需要2个及以上图片，才能拼接。" if $i < 2;

$x = int(sqrt($i));
$y = $x+1;
#~ 列数 = 文件数开平方，取整；+0的平方，+1的平方，看离哪个平方最近。
if($y**2-$i > $i-$x**2){$column = $x;}else{$column = $y;}
#~ 最宽不参与排序的个数 = $#取模列数
$dropout = $i % $column;
say "文件数 = $i，列数 = $column，最宽不参与排序的个数 = $dropout";

$suffix_w = 0;
while (glob("/tmp/w-*.png")) {
	next if -d; unlink $_ or ++$errors, warn("Can't remove $_: $!");
}

if($dropout){
	@h = ();
	while ($dropout>0){push @h, pop @r; $dropout--;}
	horizon_join(1);
}
$pop = 1;
while (@r){
	@h = ();
	for($i=0; $i<$column; $i++){
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
	for($i = 0; $i <= $#h; $i++){
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

}

