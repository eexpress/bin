#!/bin/perl

#~ parameter: dir
#~ ⭕ dir-xml-gresource.pl img/
#~ =====> img.xml
#~ =====> img.gresource
#~ /img/ara.svg
#~ /img/auto.svg
#~ /img/de.svg
#~ /img/en.svg
#~ /img/fra.svg
#~ /img/jp.svg
#~ /img/kor.svg

use 5.10.0;

$out='<?xml version="1.0" encoding="UTF-8"?>
<gresources>
	<gresource prefix="/">

';

$d = $ARGV[0];
$path = $ENV{'PWD'};
if (-d "$d"){
	use File::Find;
	find(\&wanted, $d);
	sub wanted {
		$f=$File::Find::name;
		if (-d "$path/$f") {next;}
		$out.="\t<file>".$f."</file>\n";
	}
} else {
	die 'Need a relative directory as parameter.';
}
$out.='
	</gresource>
</gresources>
';

$f = $d.".xml";
say "=====> ".$f;
open TMP, ">".$f || die "Could not open file";
print TMP $out;
close TMP;

`glib-compile-resources $f`;
$f =~ s'xml$'gresource';
say "=====> ".$f;
$list = `gresource list $f`;
say $list;

