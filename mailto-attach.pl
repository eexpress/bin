#!/usr/bin/perl -w

use strict;
use Mail::Sender;   
my $sender = new Mail::Sender; 

if($#ARGV <0){die "没有选择附件文件。\n"}
my $file=join ",",@ARGV;

#● echo youremailpassword|gpg -aer eexp01>~/bin/resources/gpg-163-password
my $pw=`gpg -d $ENV{HOME}/bin/resources/gpg-163-password`;
chomp $pw;
my $contact="$ENV{HOME}/文档/个人文件/通讯录/contacts.vcf";
#my $contact="$ENV{HOME}/.opera/contacts.adr";
open(IN,"<$contact") or die "指定通讯录文件无效。\n";
my $con=""; 
# --------------------------------------------
if($contact=~/opera/){
	# 规则。空行为段。段内取SHORT NAME和MAIL都有效的部分。
	my $name;
	while(<IN>){
	chomp;
	$name='',next if /^$/;
	$name=$',next if /\tNAME=/;
	#$name=$',next if /SHORT\ NAME=/;
	$_=$',s/\x02.*//g,$con=$con."\'$name\' \'$_\' " if /MAIL=/ && $' && $name;
	}
} else {
	my @line=<IN>; 
	my @item=split /BEGIN:VCARD/s,join "",@line;

	foreach(@item){
	s/\r//g;
	my %hash=map{split /:/} grep /FN|EMAIL/,split /\n/s;
	#while(my ($k,$v) = each %hash){print "$k => $v\n";} print "------------\n";
	#for(keys %hash){print "$hash{FN}\t$hash{$_}\n" if /EMAIL/;}
	for(keys %hash){$con=$con."\'".$hash{FN}."\' \'".$hash{$_}."\' " if /EMAIL/;}
	}
}
# --------------------------------------------
close IN;
my $to=`zenity --list --width 600 --height 500 --text="发送邮件附件，选择联系人" --column="联系人" --column="邮箱" --print-column=2 $con`;
if(!$to){die "没有选择联系人。\n"}
chomp $to;
# --------------------------------------------
print "$file\t=>\t$to\n";
my $info;
if ($sender->MailFile({
	smtp => 'smtp.163.com',
	from => 'eexpress@163.com',
	to =>$to,
	charset=>'utf-8',
	subject => '发送附件',
#        debug=>$0.'.log',
	msg => "请查看附件。",
	auth => 'LOGIN',	#LOGIN, PLAIN, CRAM-MD5 and NTLM
	authid => 'eexpress',
	authpwd => $pw,
	file => \@ARGV,
#        file => "$file",
})<0){$info="文件 $file 发送到 $to 失败\n$Mail::Sender::Error\n";}
else {$info="文件 $file 已经发送到 $to\n";}
print "$info"; `$ENV{HOME}/bin/msg mail.png "mailto-附件" "$info"`;
#● perl -MMail::Sender -e 'Mail::Sender->printAuthProtocols("smtp.163.com")'
#smtp.163.com supports: PLAIN, LOGIN

