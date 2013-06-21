#!/usr/bin/perl

$fn=$ARGV[0];
$id=`id -un`; chomp $id;
$host=`hostname`; chomp $host;
$date=`date '+%Y-%m-%d %H:%M:%S'`; chomp $date;
$_=join "-",`gpg -K`;
/(?<=2048R\/).*?\ /; $key=$&;
/<.*?>/; $email=$&; $email=~s/<//; $email=~s/>//;
#s/.*----//; s/ssb.*//; print;
$s="$fn \n$id\@$host $date $key<$email>\n";
print ">>>>>>>>>>>>\n";
print $s;
print "<<<<<<<<<<<<\n";
$_=`echo "$s"|gpg -ear "$email"`;
print;
