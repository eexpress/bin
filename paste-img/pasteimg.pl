#!/usr/bin/perl

use utf8;	# 文件路径才可以使用中文。
use Getopt::Long;

#$name="eexp";	# 缺省的昵称
$name=`id -un`; chomp $name;
$select="imagebin";	# 缺省的网站
GetOptions("select=s"=>\$select, "list"=>\$list, "help"=>\$help, "name=s"=>\$name);
#----------------------------------
if($help){
print << 'INFO';
NAME
       paste-img - Paste image to serval web hosts

SYNOPSIS
       paste-img [OPTION]... [IMAGE_FILE]...

OPTION

	-s, --select
		Select web host name. Can use short name as key word, such as "kimag" could refer to "kimag.es". All avoid host names can be list by using "-l".

	-l, --list
		List all hosts name avoid.

	-h, --help
		This help.

	-n, --name
		Nick name send to web host if support. default name is your login id name.
		
AUTHOR
	Written by eexpress (eexpress@163.com).
INFO
exit;
}
#----------------------------------
use Net::DBus; 
$bus = Net::DBus->session->get_service('org.freedesktop.Notifications')
->get_object('/org/freedesktop/Notifications','org.freedesktop.Notifications');
if(! -f $ARGV[0] && ! $list){
$bus->Notify("paste-img", 0, "error", "文件无效 .$ARGV[0].", ':(', [], { }, -1);exit;
}
#----------------------------------
%web=(
	"http://www.cjb.net/"=>{"image"=>$ARGV[0]},
	"http://kimag.es/"=>{"userfile1"=>$ARGV[0]},
	"http://imagebin.org/index.php?page=add"=>{"nickname"=>$name,"image"=>$ARGV[0],"disclaimer_agree"=>"Y"},
	"http://paste.ubuntu.org.cn/"=>{"poster"=>$name,"screenshot"=>$ARGV[0],"submit"=>"paste"},
	"http://uploadpie.com/"=>{"uploadedfile"=>$ARGV[0],"result"=>'value.*?auto_select,http[^"]*'},
# <input type="text" id="uploaded" value="http://uploadpie.com/LkkXu" onclick="auto_select();" readonly="readonly" />
#        "http://tinypic.com/"=>{"the_file"=>$ARGV[0]},	#Error GETing http://tinypic.com/ 需要图片校验 nnnnnd
#        "http://imgur.com/"=>{'file[]'=>$ARGV[0]},	#无法提交
#        "http://www.52tietu.com/"=>{"file1"=>$ARGV[0],"result"=>'value="http.*?ondblclick,http[^"]*'},	#假冒浏览器，都不返回。nnnnd
#        原图地址<br>
#        <input size="20" id="link_1_1"  value="http://img0.52tietu.com/?MF8wXzBfMjAxMDEwMDUyMjU0NTkzMw.png" ondblclick="copyText('link_1_1')"> <a href="javascript:void(0);" onclick="javascript:copyText('link_1_1');">点击复制</a>
	);
#----------------------------------
if($list){
foreach (keys %web){s'http://'';s'/.*'';$_.="\t\e[30;42m*\e[0m" if /$select/;
print "$_\n";}
exit;
}
#----------------------------------
#print "\$name=$name.\n";
#print "\$select=$select.\n";
sub pc{
my($n,$s)=@_;
printf "%-18s => .%s.\n",$n,$s;
}
#----------------------------------
use WWW::Mechanize;
use Encode;

my $add;
foreach (keys %web){$add=$_,last if /$select/;}
if(!$add){$bus->Notify("paste-img", 0, "error", '无效网站地址', ':(', [], { }, -1);exit;}
pc "select","\e[30;42m$select\e[0m";
#----------------------------------
%h=%{$web{$add}};
while(my($k,$v)=each %h){pc $k,$v;}
$submit="";if($h{"submit"}){$submit=$h{"submit"}; delete $h{"submit"};}
$result="";if($h{"result"}){$result=$h{"result"}; delete $h{"result"};}
#----------------------------------
my $mech = WWW::Mechanize->new();
#my $mech = WWW::Mechanize->new(agent=>'Opera/9.80 (X11; Linux i686; U; en) Presto/2.6.30 Version/10.60');
$mech->get($add);
if($submit eq "") {$mech -> submit_form(with_fields=>\%h);}
else{$mech -> submit_form(with_fields=>\%h,button=>$submit);}
#----------------------------------
if ($mech->success()) {
	if($result eq ""){$rr=$mech->uri();}
	else{
		$rr=$mech->content();
		$rr=encode("utf-8",decode("gbk",$rr));
#                print $rr;
		@ss=split ",",$result;
		foreach (@ss){
			$rr=~/$_/m; $rr=$&;
			pc "parse",$rr;
			}
	}
	pc "Paste URL","\e[30;42m$rr\e[0m";
	$bus->Notify("paste-img", 0, "sunny", '贴图地址(已复制到剪贴板)', $rr, [], { }, -1);
	`echo $rr|xsel -i`;
} else {
	$bus->Notify("paste-img", 0, "error", '贴图失败', ':(', [], { }, -1);
}
#----------------------------------

