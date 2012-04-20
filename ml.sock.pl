#!/usr/bin/perl  
  
use IO::Socket::INET;  
use Number::Format qw/format_bytes/;
#libnumber-format-perl 
my $sock = IO::Socket::INET->new(PeerAddr => 'localhost', PeerPort => 4000) or die "没找到mlnet的端口。\n";  

$prompt="\e[32m--命令--> \e[0m";
print "命令查看 ? 。支持alias。使用 / 搜索最后的输出。\n";
print $prompt;
while(<>){
last if /^quit|^exit|^q$/;
if(/^\//){ #增加搜索最后的一次输出。
	$s=$'; chomp $s;
	@_=grep /$s/i,@l;
	print @_;
}else{
	@l=[];
	print $sock $_;
	$vr=/vr/?1:0;
	$vd=/vd/?1:0;
	while(<$sock>){last if /^>/;}
	print $_;
while(<$sock>){last if /command-line/;
	if($vr){
		s/]\ (\d)/]  $1/; @_=split /\s{2,}/;
		next if $_[2]!~/^\d+$/; next if $_[2]<10000000;
		$_=$_[0].$_[1]."  ".format_bytes($_[2])."  ".substr($_[4],0,50)."\n";
		}
	if($vd){
		next if /Rate|files/;
		if(/\[[DBT]/){
		s/].*mldonkey/] /; @_=split /\s{2,}/;
		$_="$_[0] $_[1]  $_[3]%  $_[4]/$_[5]  ".substr($_[2],0,50)."\n";
		}
		}
	print $_;
	push @l,$_;
	}
}
print $prompt;
}
print "\e[H\e[2J"; # tput clear
close $sock;  

