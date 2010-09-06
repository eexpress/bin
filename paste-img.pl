#!/usr/bin/perl -w

use utf8;
use strict;
use WWW::Mechanize;
use Net::DBus;

my $bus = Net::DBus->session->get_service('org.freedesktop.Notifications')
->get_object('/org/freedesktop/Notifications','org.freedesktop.Notifications');
my $mech = WWW::Mechanize->new();
#选择贴图网站的缩写短语，会在列表中自动匹配的
my $web_select="imagebin";
#my $web_select="kimag";
#my $web_select="cjb";
#my $web_select="ubuntu";
my $add;
#======================
my %web=(	"http://www.cjb.net/"=>{"image"=>$ARGV[0]},
		"http://kimag.es/"=>{"userfile1"=>$ARGV[0]},
		"http://imagebin.org/index.php?page=add"=>{"nickname"=>"eexp","image" => $ARGV[0],"disclaimer_agree"=>"Y"},
		"http://paste.ubuntu.org.cn/"=>{"poster"=>"eexp","screenshot"=>$ARGV[0],"code2"=>join("\n",`xsel -o`)},	#submit名不对
#                "http://tinypic.com/"=>{"the_file"=>$ARGV[0]},	#Error GETing http://tinypic.com/ 需要图片校验 nnnnnd
#                "http://imgur.com/"=>{'file[]'=>$ARGV[0]},	#无法提交
	);
foreach (keys %web){$add=$_,last if /$web_select/;}
if(!$add){$bus->Notify("paste-img", 0, "error", '无效网站地址', ':(', [], { }, -1);exit;}
print $web_select."\n";
#======================
$mech -> get($add);
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

