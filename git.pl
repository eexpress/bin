#!/usr/bin/perl

my $bold="\e[1m"; my $red="\e[31m"; my $normal="\e[0m";

chdir "$ENV{HOME}/bin";
@_=`git status`;
if($_[-1] =~ /nothing added to commit/){
print "本地无更新，自动获取远程更新。\n";
`git pull`;
exit;
}
@_=grep /modified:|new file:/,@_;
if(@_){
print @_;
print "本地需要提交。请输入提交的注释并回车（空注释将被日期代替）：\n$red$bold";
$_=<STDIN>; chomp;
if(! $_){$_=`date '+%F %T'`; chomp;}
print "$normal提交注释为 $_ 的更新。\n";
`git ci -a -m \"$_\"; git pull; git push`;
exit;
}
