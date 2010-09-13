#!/usr/bin/perl -w

use utf8;
#use strict;
use WWW::Mechanize;
use Net::DBus;
use Getopt::Long;

#======================
my %web=(
	"http://www.cjb.net/"=>{"image"=>$ARGV[0]},
	"http://kimag.es/"=>{"userfile1"=>$ARGV[0]},
	"http://imagebin.org/index.php?page=add"=>{"nickname"=>"eexp","image" => $ARGV[0],"disclaimer_agree"=>"Y"},
	"http://paste.ubuntu.org.cn/"=>{"poster"=>"eexp","screenshot"=>$ARGV[0],"code2"=>join("\n",`xsel -o`)},	#submit名不对
#        "http://tinypic.com/"=>{"the_file"=>$ARGV[0]},	#Error GETing http://tinypic.com/ 需要图片校验 nnnnnd
#        "http://uploadpie.com/"=>{"uploadedfile"=>$ARGV[0]},	#需要读取结果网页，估计还要模拟同一浏览器
#        "http://imgur.com/"=>{'file[]'=>$ARGV[0]},	#无法提交
	);
#======================
$default="imagebin";
#$default="kimag";
#$default="cjb";
#$default="ubuntu";

GetOptions('select=s'=>\$select);
my $bus = Net::DBus->session->get_service('org.freedesktop.Notifications')
->get_object('/org/freedesktop/Notifications','org.freedesktop.Notifications');

if(! $ARGV[0]){
print "Paste image file to web below, the default web is $default.\n";
foreach (keys %web){m'(?<=http://).*?(?=/)'; print "=>\t$&\n";}
print "You can select another use '-s' follow by any specail word of those web name.\n";
exit;
}
if(! -f $ARGV[0]){$bus->Notify("paste-img", 0, "error", '贴图失败', "$ARGV[0] 文件不存在", [], { }, -1); exit;}

my $mech = WWW::Mechanize->new();
#选择贴图网站的缩写短语，会在列表中自动匹配的
$select=$default if ! $select;
my $add;
#======================
foreach (keys %web){$add=$_,last if /$select/;}
if(!$add){$bus->Notify("paste-img", 0, "error", '贴图失败', "无效网站地址 $select :(", [], { }, -1);exit;}
print "$select => $add\n";
#======================
$mech->get($add);
#if(! $mech->success()){$bus->Notify("paste-img", 0, "error", '贴图失败', "$add 网站无法连接", [], { }, -1); exit;}
#$mech -> submit_form(with_fields => $web{$add});
if($add!~/ubuntu/) {$mech -> submit_form(with_fields => $web{$add});}
else{$mech -> submit_form(with_fields => $web{$add},button=>"paste");}
#======================
if ($mech->success()) {
	my $rr=$mech->uri();
	print "贴图地址： $rr 。\n";
	`echo $rr|xsel -i`;
	$bus->Notify("paste-img", 0, "sunny", '贴图地址', $rr, [], { }, -1);
} else {
	$bus->Notify("paste-img", 0, "error", '贴图失败', ':(', [], { }, -1);
	print "ERROR:\t".$mech->status()."\n";
}
#======================

