#!/usr/bin/perl

$g=`identify -format "%wx%h" "$ARGV[0]"`;
chomp $g;
$r=`zenity  --entry --text="转换尺寸格式：1。数值宽度；2。x数字高度；3。百分比"  --entry-text=$g --title="批量转换图片尺寸"`;
chomp $r;
foreach(@ARGV){
`convert "$_" -scale $r "$_"`;
}
