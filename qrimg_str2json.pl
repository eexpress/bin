#!/usr/bin/perl

#ss://method:password@server:port
#ssr://server:port:protocol:method:obfs:password_base64/?params_base64

if(! $ARGV[0]){print "input qrcode image file or ss/ssr format string.\noutput json format text.\n";exit;}

$_=$ARGV[0]; $outfile="new"; $remark="new";
if(-f "$_"){
	$outfile=$_; $remark=$_; $remark=~s'.*/''g; $remark=~s'\ '_'g;
	#缺省的remark是文件名。
	$_=`zbarimg "$_"`;
}
if(! m'ssr?://'){print "no valid ss:// or ssr:// string.";exit;}

if(/^ssr:/){
	$ssr=1;
}else{
	$ssr=0; s/-/+/g; s/_/\//g;
}
s'.*//'';
$l1=`echo "$_"|base64 -d`;
$_=$l1;
if(! $ssr){
	s/\@/:/;
	@i=split ':';
	$out = <<"END";
========================================
{
"remarks"	:	"$remark",
"method"	:	"$i[0]",
"password"	:	"$i[1]",
"server"	:	"$i[2]",
"server_port"	:	"$i[3]"
}
========================================
$outfile.json
END
	print $out;
}
else{
	s/(.*)\/\?/\1:/;	#贪婪匹配最后一个/?remarks=号，换成:
	@i=split ':';
	$i[5]=`echo "$i[5]"|base64 -d`;
	if($i[6]=~/^remarks=/){
		$remark=`echo "$'"|base64 -d`;
		$outfile=$remark if $outfile eq "new";
	}
	$out = <<"END";
========================================
{
"remarks"	:	"$remark",
"server"	:	"$i[0]",
"server_port"	:	"$i[1]",
"protocol"	:	"$i[2]",
"method"	:	"$i[3]",
"obfs"		:	"$i[4]",
"password"	:	"$i[5]"
}
========================================
$outfile.json
END
	print $out;
}
#open OUT,">$outfile.json";
#print OUT $out;
#close OUT;

