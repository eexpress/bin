#!/usr/bin/perl

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
print "本地需要提交。请输入提交的注释并回车（空注释将被日期代替）：\n";
$_=<STDIN>; chomp;
if(! $_){$_=`date '+%F %T'`; chomp;}
print "提交注释为 $_ 的更新。";
`git ci -a -m \"$_\"; git push`;
exit;
}
