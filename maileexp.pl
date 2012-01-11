#!/usr/bin/perl -w

if($#ARGV<0){die "没有选择附件文件。\n"}
# --------------------------------------------
$_=`hostname`; chomp;
$d=/desktop/?1:0;
my $to="eexp0$d\@gmail.com";
my $file=join ",",@ARGV;
my $info="send $to attach with $file\n";
print "$info"; `$ENV{HOME}/bin/msg mail.png "mailto-附件" "$info"`;
# --------------------------------------------
use Mail::Sender;   
my $sender = new Mail::Sender; 
#● echo youremailpassword|gpg -aer eexp01>~/bin/resources/gpg-163-password
my $pw=`gpg -d $ENV{HOME}/bin/resources/gpg-163-password`; chomp $pw;
if ($sender->MailFile({
	smtp => 'smtp.163.com',
	from => 'eexpress@163.com',
	to =>$to,
	charset=>'utf-8',
	subject => '同步文件。发送附件',
	msg => "请查看附件。",
	auth => 'LOGIN',
	authid => 'eexpress',
	authpwd => $pw,
	file => \@ARGV,
})<0){$info="文件 $file 发送到 $to 失败\n$Mail::Sender::Error\n";}
else {$info="文件 $file 已经发送到 $to\n";}
print "$info"; `$ENV{HOME}/bin/msg mail.png "mailto-附件" "$info"`;
# --------------------------------------------

