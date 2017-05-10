#!/usr/bin/perl

if(! $ARGV[0]){print "input qrcode image file or ss format string.\n";exit;}
$_=$ARGV[0]; $file=$_;
$mark=$file; $mark=~s'.*/''g; $mark=~s'\ '_'g;
$_=`zbarimg "$_"` if -f "$_";
if(! m'ssr?://'){print "no valid ss:// string.";exit;}
print;
$ssr=0; $ssr=1 if /ssr:/;
s'.*//'';
$_=`echo "$_"|base64 -d`;
s/j\[$//g;		# 尾巴上老多出一个"j["
if(/\?remarks=/){$_=$`;$mark=`echo $'|base64 -d`; chomp $mark;}
s/(.*)@/\1:/;	#贪婪匹配最后一个@号，换成:
print "$_\n";
@i=split ':';
if($ssr==0){
$out = <<"END";
{
"remarks"	:	"$mark",
"method"	:	"$i[0]",
"password"	:	"$i[1]",
"server"	:	"$i[2]",
"server_port"	:	"$i[3]"
}
END
	print $out;
}
else{
# need modify for ssr format.
$out = <<"END";
{
"remarks"	:	"$mark",
"server"	:	"$i[0]",
"server_port"	:	"$i[1]",
"protocol"	:	"$i[2]",
"method"	:	"$i[3]",
"obfs"		:	"$i[4]",
"password"	:	"$i[5]"
}
END
	print $out;
}
open OUT,">$file.json";
print OUT $out;
close OUT;

