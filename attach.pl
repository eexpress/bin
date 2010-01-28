#!/usr/bin/perl

my @t=glob "/tmp/dtach*";
$pre=""; if(! -t STDOUT){$pre="xterm -e";}
#$on_a_tty = -t STDIN && -t STDOUT;
#print $on_a_tty; exit 0;
#my @t=glob "/tmp/ssh*";
#my @t=glob "/tmp/scim*";
#if($#t<0){die "没有文件可以连接。"};
if($#t<0){system("msg dtach 没有可连接的sock");exit 1;};
if($#t==0){system("$pre dtach -a $t[0]");exit 0};

#---------------------------
#---------------------------
print "多个目标，用数字选择需要连接的文件。\n";
for (0 .. $#t){
print "$_\t$t[$_]\n";
}

use Term::ReadKey qw/ReadKey ReadMode/;
ReadMode 4;
do {
#while (not defined ($key = ReadKey(0))){}
$key = ReadKey(0);
} while ($key<0 || $key>$#t);
#为什么其他字符都有效，除开$#t-9
ReadMode 0;
#goto REKEY if(not defined $t[$key]);
print "选择了 $key\n";print "$t[$key]\n";
#---------------------------
system("$pre dtach -a $t[$key]");
