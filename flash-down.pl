#!/usr/bin/perl -w

use utf8;
use strict;
use WWW::Mechanize;
use Net::DBus;
binmode STDOUT, ':utf8';

use Getopt::Long;
my $view; my $help;
GetOptions('view'=>\$view,'help'=>\$help);

if($help){
print <<HELP;
AUTHOR:         eexpress
VERSION:        1.2
USAGE:          flash-down.pl [--view] [--help] url
HELP
exit 0;
}

use File::Pid;
my $pidfile=File::Pid->new({file=>'/tmp/flash-down.pid'});
if(my $num=$pidfile->running){print $pidfile->program_name." is already running with PID: $num\nwait....\n";}
while ($pidfile->running){ sleep 5; }
$pidfile->write;

my $black="\e[30m";my $red="\e[31m";my $green="\e[32m";
my $yellow="\e[33m";my $blue="\e[34m";my $pink="\e[35m";
my $cyan="\e[36m";my $white="\e[37m";my $normal="\e[0m";
my $bold="\e[1m";my $reverse="\e[7m";

my $dir="$ENV{HOME}/视频/";
-d $dir && chdir $dir;

$_=$ARGV[0];
s/^http:\/([a-z0-9])/http:\/\/$1/;
chomp; s/\//%2F/g; s/:/%3A/g;
$_="http://www.flvcd.com/parse.php?flag=&format=high&kw=$_&sbt=%BF%AA%CA%BCGO%21";

my $bus = Net::DBus->session->get_service('org.freedesktop.Notifications')->get_object('/org/freedesktop/Notifications','org.freedesktop.Notifications');
my $mech = WWW::Mechanize->new(agent=>'Opera/9.80 (X11; Linux i686; U; en) Presto/2.6.30 Version/10.60');
#my $mech = WWW::Mechanize->new();
$mech -> get($_);
if ($mech->success()) {
	$_=$mech->content();
	if(/网络限制/){
		/网络限制.*\.\.\./; $_=$&; s/<br\/>.*$//; 
		$bus->Notify("flash", 0, "error", "flash 解析失败", "$_\n:(", [], { }, -1);
	} else {
	if(/当前解析视频.*?<strong/s){
	$_=$&; 
	s/^.*?>//;s/<.*$//s;s/\s*//g;
	print "$red$bold".$_."$normal==================\n";
	my $name="$_";
	my @alllink=$mech->find_all_links(text_regex => qr/http:\/\/.*[0-9a-fA-F]*/,);
#    delete link with blog.flvcd.com
#    foreach(@link){
#        delete if /blog.flvcd.com/;
#    }
	my @link=grep(!/blog\.flvcd\.com/,@alllink);
	my $size=@link;
	$bus->Notify("flash", 0, "sunny", "$name", "共获取 $size 个地址。", [], { }, -1);
	print "\e]2;flash-down.pl_下载_$name\a";
	print map "=> $green".$_->url()."$normal\n",@link;
print $alllink[0];
	$pidfile->remove; exit;
#    open(LINK,">link.log"); print LINK map $_->url()."\n",@link; close LINK;
	my $cnt=1; my $proc="▭"x$size;
#---------------------	
if($view){
	foreach(@link){
		my $add=$_->url();
		`mplayer -quiet $add`;
		}
		$pidfile->remove;
		exit;
}
#---------------------	
	if($size>4){mkdir "$_"; chdir "$_";}
	foreach(@link){
		my $add=$_->url();
#        print "$red 下载$normal => $green$add$normal\n";
		my $file=$size>1?sprintf "%s-%02d.flv",$name,$cnt:"$name.flv";
#        or use try/catch in Try::Tiny
		eval{
			$mech->get($add);
			$mech->save_content($file);
			$_=$mech->success()?"■":"□";$proc=~s/▭/$_/;
		};
		if($@){
			`wget -c --tries=5 --user-agent='Opera/9.80 (X11; Linux i686; U; en) Presto/2.6.30 Version/10.60' "$add" -O $file`;
			$_=$?==0?"■":"□";$proc=~s/▭/$_/; 
		}
		if($size>1){
			$bus->Notify("flash", 0, ($?==0?"sunny":"error"), "$name", "已经完成下载 $cnt / $size ，返回：$? 。\n进度：$proc", [], { }, -1);
			print "$red$bold$name 已经完成下载 $cnt / $size$normal ，返回：$? 。进度：$red$bold$proc$normal\n";
			print "\e]2;$name $proc\a";
		}
		$cnt++;
	}
#---------------------	
	$bus->Notify("flash", 0, "sunny", "$name 已经完成全部下载", "", [], { }, -1);
#    chdir '..';
	`echo "$ARGV[0]\t《$_》\t结果：$proc">>/tmp/flash-down.log`;
	`paplay "/usr/share/sounds/ubuntu/stereo/service-login.ogg"`;
	}
	}
} else {
	$bus->Notify("flash", 0, "gtk-cancel", '网页无效', ':(', [], { }, -1);
}

$pidfile->remove;
#======================
