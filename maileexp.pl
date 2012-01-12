#!/usr/bin/perl -w

if($#ARGV<0){die "没有选择附件文件。\n"}
# --------------------------------------------
$_=`hostname`; chomp;
$d=/desktop/?1:2;
my $to="eexp0$d\@gmail.com";
my $file=join ",",@ARGV;
my $info="发送文件: $file 到邮箱: $to";
#● echo password|gpg -aer eexp01>~/bin/resources/gpg-163-password
my $pw=`gpg -d $ENV{HOME}/bin/resources/gpg-163-password`; chomp $pw;
print "$info\n"; `$ENV{HOME}/bin/msg mail.png "发送邮件附件" "$info"`;
# --------------------------------------------
use Mail::Sender;   
my $sender = new Mail::Sender; 
if ($sender->MailFile({
	smtp => 'smtp.163.com',
	from => 'eexpress@163.com',
	to =>$to,
	charset=>'utf-8',
	subject => '同步文件。',
	charset => 'utf-8',
	msg => "请查看附件。",
	auth => 'LOGIN',
	authid => 'eexpress',
	authpwd => $pw,
	file => \@ARGV,
})<0){$info="失败。错误：$Mail::Sender::Error";}
else {$info="完成";}
print "$info\n"; `$ENV{HOME}/bin/msg mail.png "发送邮件附件" "$info"`;
# --------------------------------------------

