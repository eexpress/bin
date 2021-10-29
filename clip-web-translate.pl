#!/usr/bin/perl

use utf8;
use URI::Escape;
#----------------------------------
	$_=`xclip -o`;	#获取选择的文字
	s/\n/\ /g;	#用于manpage多行合并
	$uri=uri_escape($_);

	$prefix="http://www.iciba.com/word?w=";
	#~ $prefix="https://fanyi.baidu.com/#en/zh/";

	`xdg-open \'$prefix$uri\'`;
#----------------------------------

