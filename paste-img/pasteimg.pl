#!/usr/bin/perl

use utf8;	# 文件路径才可以使用中文。
use Getopt::Long;
use Pod::Usage;

#$name="eexp";	# 缺省的昵称
$name=`id -un`; chomp $name;
$select="ubuntu";	# 缺省的网站
GetOptions("select=s"=>\$select, "list"=>\$list, "help"=>\$help, "name=s"=>\$name, "confirm"=>\$confirm);
#----------------------------------
%web=(
	"http://paste.ubuntu.org.cn/"=>{"poster"=>$name,"screenshot"=>'xxxx',"submit"=>"paste"},
	"http://uploadpie.com/"=>{"uploadedfile"=>'xxxx',"result"=>'value.*?auto_select,http[^"]*'},
	"http://picpaste.com/"=>{"upload"=>'xxxx',"rules"=>"yes","result"=>'Picture\ URL.*?/a,http[^"]*'},
	"http://imagebin.org/index.php?page=add"=>{"nickname"=>$name,"image"=>'xxxx',"disclaimer_agree"=>"Y"},
#    "http://ompldr.org/"=>{"file1"=>'xxxx',"result"=>'BBCode.*?img,http[^]]*'},
#    "http://imm.io/"=>{"image"=>'xxxx'},		#改js了
#    "file://localhost/home/eexp/imm.io.html"=>{"image"=>'xxxx'},
#    "http://www.cjb.net/"=>{"image"=>'xxxx'},	#废弃
#    "http://bkup.co/"=>{"file1"=>'xxxx'},
#    "http://kimag.es/"=>{"userfile1"=>'xxxx'},
#        "http://twpic.org/"=>{"attached"=>'xxxx',"result"=>'url.*?url,http[^\[]*'},
#        <textarea name="textarea" cols="100" wrap="soft" rows="3">[url=http://twpic.org][img]http://twpic.org/uploads2/6ed6ac3661.png[/img][/url]</textarea 无法获取结果网页。
#        "http://tinypic.com/"=>{"the_file"=>'xxxx'},	#Error GETing http://tinypic.com/ 需要图片校验 nnnnnd
#        "http://imgur.com/"=>{'file[]'=>'xxxx'},	#无法提交
#        "http://www.52tietu.com/"=>{"file1"=>'xxxx',"result"=>'value="http.*?ondblclick,http[^"]*'},	#假冒浏览器，都不返回。nnnnd
#        原图地址<br>
#        <input size="20" id="link_1_1"  value="http://img0.52tietu.com/?MF8wXzBfMjAxMDEwMDUyMjU0NTkzMw.png" ondblclick="copyText('link_1_1')"> <a href="javascript:void(0);" onclick="javascript:copyText('link_1_1');">点击复制</a>
	);
#----------------------------------
if($help){pod2usage(-verbose => 2); exit;}
#----------------------------------
if($list){
	print "Supported image pastebins:\n";
foreach (keys %web){
	if(/^file/){ s'.*/''; }else{ s'http://'';s'/.*''; }
#    $_.="\t\e[30;42m*\e[0m" if /$select/;
	print /$select/?"\e[30;42m\t* $_\t\e[0m\n":"\t- $_\n";
#    print "$_\n";
}
exit;
}
#`echo $ARGV[0]>>/tmp/pi-file`;
#----------------------------------
use Net::DBus; 
$bus = Net::DBus->session->get_service('org.freedesktop.Notifications')
->get_object('/org/freedesktop/Notifications','org.freedesktop.Notifications');
if(! $ARGV[0]){
my $fp='/tmp/pi.png';
	print "after cursor changed, use mouse to take screenshot...\n";
	$bus->Notify("paste-img", 0, "info", "准备截图", "光标改变后，使用鼠标截图。。。", [], { }, -1);
	unlink $fp;
	`/usr/bin/gnome-screenshot -af $fp`;
#    if(-f '/usr/bin/scrot'){`/usr/bin/scrot -sb $fp`;}
#    elsif(-f '/usr/bin/import'){`/usr/bin/import -frame $fp`;}
	$ARGV[0]=$fp; 
}
$ARGV[0]=~s'file://'';
#$ARGV[0]=~s/\%([A-Fa-f0-9]{2})/chr(hex($1))/seg;
$ARGV[0]=~s/\%([A-Fa-f0-9]{2})/pack('C', hex($1))/seg;
if(! -f $ARGV[0]){
	`echo $ARGV[0]>/tmp/pasteimg.fail.log`;
$bus->Notify("paste-img", 0, "error", "文件无效 .$ARGV[0].", ':(', [], { }, -1);exit;
}
#print Data::Dumper->Dump([[%web]]);exit;
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
while(my($k,$v)=each %h){if($v eq 'xxxx'){$h{$k}=$ARGV[0];$v=$ARGV[0]}; pc $k,$v;}
$submit="";if($h{"submit"}){$submit=$h{"submit"}; delete $h{"submit"};}
$result="";if($h{"result"}){$result=$h{"result"}; delete $h{"result"};}
#----------------------------------
if($confirm){
my $file=decode("utf-8",$ARGV[0]);
`zenity --question --title=确认贴图 --text="是否将 $file 贴图到 $select 网站？"`;
if($?){exit;}
#pc "zenity: $?"; exit;
}
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
#                $rr=encode("utf-8",decode("gbk",$rr));
#                s/[\[\]]/ /g;
#                print $rr;
		@ss=split ",",$result;
		foreach (@ss){
			$rr=~/$_/s; $rr=$&;
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
=pod

=head1 NAME

B<paste-img> - Paste image to serval web hosts, URL return in clipboard(PRIMARY).

=head1 SYNOPSIS

B<paste-img> [OPTION]... [IMAGE_FILE]...

=head1 OPTION

=head2 -s, --select

Select web host name. Can use short name as key word, such as "kimag" could refer to "kimag.es". All available host names can be list by using "-l".

=head2 -l, --list

List all hosts name available.

=head2 -h, --help

This help.

=head2 -n, --name

Nick name send to web host if support. default name is your login id name.

=head2 -c, --confirm

confirm to upload pic. for some app need.

=head2 no argument

Auto start screenshot, and then paste.

=head1 AUTHOR

Written by I<eexpress> (eexpress@163.com).

=cut
