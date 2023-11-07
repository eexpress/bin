#!/bin/perl

#~ 将多个路径下的文件，建立res.xml列表，并打包成res.gresource文件。
#~ ⭕ dir-xml-gresource.pl img icon
#~ =====> res.xml
#~ =====> res.gresource
#~ /img/ara.svg
#~ /img/auto.svg
#~ /img/de.svg
#~ /icon/fra.svg
#~ /icon/jp.svg

use 5.10.0;

if (! scalar @ARGV){
	die 'Need (multiple) relative directory as parameter.';
}

$out='<?xml version="1.0" encoding="UTF-8"?>
<gresources>
	<gresource prefix="/">

';

use File::Find;
# 支持数组 @directories_to_search 。
find({ wanted => \&wanted, no_chdir => 1 }, @ARGV);
sub wanted {
	$out.="\t<file>".$_."</file>\n" if -f;
}

$out.='
	</gresource>
</gresources>
';

$f = "res.xml";
say "=====> ".$f;
open TMP, ">".$f || die "Could not open file";
print TMP $out;
close TMP;

`glib-compile-resources $f`;
$f = "res.gresource";
say "=====> ".$f;
$list = `gresource list $f`;
say $list;

#~ 从gresource文件释放全部资源
#~ ⭕ pi glib2-devel
#~ ⭕ gresource list res.gresource
#~ /img/r1.svg
#~ /img/r2.svg
#~ /img/r3.svg
#~ /img/r4.svg
#~ /img/r5.svg
#~ /img/r6.svg
#~ /img/r7.svg
#~ /img/r8.svg
#~ /img/r9.svg
#~ ⭕ gresource list res.gresource | while read i; do gresource extract res.gresource $i>./$i; done
