#!/usr/bin/perl

my $Bred="\e[1;31m"; my $Bblue="\e[1;34m"; my $normal="\e[0m";

chdir "$ENV{HOME}/bin";
@_=`git status`;
if($_[-1] =~ /nothing added to commit|提交为空/){
	print "本地无更新，自动获取远程更新。\n";
	`git pull`;
#    `echo 'finish'; read -n 1`;
	exit;
}
@_=grep /modified:|new file:|deleted:|修改：|删除：|新文件：|重命名：/,@_;
if(@_){
	print "文件:\n @_";
	@_=grep /\d+m[-+]/,`git diff`;
	print "差异: \n @_";
	@_=`git remote`;
	print "仓库:\n$Bblue @_ $normal \n";
	print "本地需要提交。请输入提交的注释并回车（空注释将被日期代替）：\n$Bred";
	$_=<STDIN>; chomp;
	if(! $_){$_=`date '+%F %T'`; chomp;}
	print "$normal提交注释为 $Bblue $_ $normal 的更新。\n";
#`git ci -a -m \"$_\"; git pull; git push`;
	`git ci -a -m \"$_\"; git push`;
	exit;
}
