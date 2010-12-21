#!/usr/bin/perl -w

use strict;

if($#ARGV <0){die "没有选择附件文件。\n"}
my $file=join ",",@ARGV;
#my $file=join ",",map("\'$_\'",@ARGV);
#print "$#ARGV\n$file\n";

use Mail::Sender;   
my $sender = new Mail::Sender; 

# --------------------------------------------
my $contact="$ENV{HOME}/.opera/contacts.adr";
# 规则。空行为段。段内取SHORT NAME和MAIL都有效的部分。
my $con; my $name; my $info;
if (open(PN,$contact)){
while(<PN>){
chomp;
$name='',next if /^$/;
$name=$',next if /\tNAME=/;
#$name=$',next if /SHORT\ NAME=/;
$_=$',s/\x02.*//g,$con=$con."\'$name\' \'$_\' " if /MAIL=/ && $' && $name;
}
}
close(PN);
my $to=`zenity --list --width 600 --height 500 --text="发送邮件附件，选择联系人" --column="联系人" --column="邮箱" --print-column=2 $con`;
if(!$to){die "没有选择联系人。\n"}
chomp $to;
# --------------------------------------------
print "$file\t=>\t$to\n";
if ($sender->MailFile({
	smtp => 'smtp.163.com',
	from => 'eexpress@163.com',
	to =>$to,
	charset=>'utf-8',
	subject => '发送附件',
	debug=>$0.'.log',
	msg => "请查看附件。",
	auth => 'LOGIN',	#LOGIN, PLAIN, CRAM-MD5 and NTLM
	authid => 'eexpress',
	authpwd => '01220539',
	file => \@ARGV,
#        file => "$file",
})<0){$info="文件 $file 发送到 $to 失败\n$Mail::Sender::Error\n";}
else {$info="文件 $file 已经发送到 $to\n";}
print "$info"; `$ENV{HOME}/bin/msg mail.png "mailto-附件" "$info"`;
#● perl -MMail::Sender -e 'Mail::Sender->printAuthProtocols("smtp.163.com")'
#smtp.163.com supports: PLAIN, LOGIN

