#!/usr/bin/perl -w

# --------------------------------------------
-f $ARGV[0] or die "没有指定附件文件。";
my @file; for (@ARGV){push @file,$_ if -f;}
my $files; for(@file){$files.="\'$_\',";}
my $rc="$ENV{HOME}/.config/sendmail.cfg";
#● chmod go-rw .config/sendmail.cfg 
open RC,"<$rc"; @rc=grep ! /^\s*#/ && ! /^\s*$/,<RC>; close RC;
my %hrc=map{split /\s*=/} @rc;
chomp %hrc;
foreach (keys %hrc){$hrc{$_}=~s/['"]//g;}
#while(my ($k,$v) = each %hrc){print "$k => $v\n";}
my $contact=$hrc{contactfile};
-f $contact or $contact=`locate -beLin 1 *.vcf`;
# --------------------------------------------
open(IN,"<$contact") or die "指定通讯录文件无效。\n";
	my $con=""; 
	my @line=<IN>; 
	my @item=split /BEGIN:VCARD/s,join "",@line;

	foreach(@item){
	s/\r//g;
	my %hash=map{split /:/} grep /FN|EMAIL/,split /\n/s;
	for(keys %hash){$con=$con."\'".$hash{FN}."\' \'".$hash{$_}."\' " if /EMAIL/;}
	}
close IN;
# --------------------------------------------
my $to=`zenity --list --width 600 --height 500 --text="发送邮件附件，选择联系人" --column="联系人" --column="邮箱" --print-column=2 $con`;
if(!$to){die "没有选择联系人。\n"}
chomp $to; print "$files\t=>\t$to\n";
# --------------------------------------------
use strict;
use Mail::Sender;   
my $sender = new Mail::Sender; 

my $info;
if ($sender->MailFile({
	smtp => $hrc{smtp}, from => $hrc{from}, authid => $hrc{authid}, authpwd => $hrc{authpwd},
	to =>$to, file => \@file,
	charset=>'utf-8', subject => '请查阅附件', auth => 'LOGIN',
	msg => "附件包括：$files。",
})<0){$info="文件 $files 发送到 $to 失败\n$Mail::Sender::Error\n";}
else {$info="文件 $files 已经发送到 $to\n";}
print "$info"; `$ENV{HOME}/bin/msg mail.png "mailto-附件" "$info"`;
# --------------------------------------------
