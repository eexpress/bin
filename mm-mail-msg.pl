#!/usr/bin/perl -w

# ---------指定通讯录文件，支持vcf和opera的格式
my $contact="$ENV{HOME}/文档/个人/contacts.vcf";
my $contact="$ENV{HOME}/.opera/contacts.adr";
#如果输入是文件，就发邮件。否则，发短信。
my $key=(-f $ARGV[0])?'EMAIL|MAIL':'TEL|PHONE';
# --------------------------------------------
use strict;
use Mail::Sender;   
my $sender = new Mail::Sender; 

if($#ARGV <0){die "没有选择附件文件或者信息内容。\n"}
my $file=join ",",@ARGV;
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
	$_=$',s/\x02.*//g,$con=$con."\'$name\' \'$_\' " if /$key=/ && $' && $name;
	}
} else {
	my @line=<IN>; 
	my @item=split /BEGIN:VCARD/s,join "",@line;

	foreach(@item){
	s/\r//g;
#        my %hash=map{split /:/} grep /FN|EMAIL/,split /\n/s;
	my %hash=map{split /:/} grep /FN|$key/,split /\n/s;
	for(keys %hash){$con=$con."\'".$hash{FN}."\' \'".$hash{$_}."\' " if /$key/;}
	}
}
# --------------------------------------------
close IN;
my $to=`zenity --list --width 600 --height 500 --text="发送邮件附件，选择联系人" --column="联系人" --column="$key" --print-column=2 $con`;
if(!$to){die "没有选择联系人。\n"}
chomp $to;
# --------------------------------------------
if (-f $ARGV[0]){
print "$file\t=>\t$to\n";
#● echo youremailpassword|gpg -aer eexp01>~/bin/resources/gpg-163-password
my $pw=`gpg -d $ENV{HOME}/bin/resources/gpg-163-password`;
chomp $pw;
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
}
#● perl -MMail::Sender -e 'Mail::Sender->printAuthProtocols("smtp.163.com")'
#smtp.163.com supports: PLAIN, LOGIN
# --------------------------------------------
else{
`cliofetion -f -t -m`;
}
