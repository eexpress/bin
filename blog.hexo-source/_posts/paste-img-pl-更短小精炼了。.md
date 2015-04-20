title: paste-img.pl 更短小精炼了。
date: 2010-01-04 05:01:11
tags:
---

● cat paste-img.pl 
#!/usr/bin/perl -w

use utf8;
use strict;
use WWW::Mechanize;
use Net::DBus;

my $bus = Net::DBus-&gt;session-&gt;get_service("org.freedesktop.Notifications")
-&gt;get_object("/org/freedesktop/Notifications","org.freedesktop.Notifications");
my $mech = WWW::Mechanize-&gt;new();
my $web_select="imagebin";	#选择贴图网站的缩写短语，会在列表中自动匹配的
my $add;
#======================
my %web=(	"[http://www.cjb.net/](http://www.cjb.net/)"=&gt;{"image"=&gt;$ARGV[0]},
		"[http://kimag.es/](http://kimag.es/)"=&gt;{"userfile1"=&gt;$ARGV[0]},
		"[http://imagebin.org/index.php?page=add](http://imagebin.org/index.php?page=add)"=&gt;{"nickname"=&gt;"eexp","image" =&gt; $ARGV[0],"disclaimer_agree"=&gt;"Y"},
		"[http://paste.ubuntu.org.cn/](http://paste.ubuntu.org.cn/)"=&gt;{"poster"=&gt;"eexp","screenshot"=&gt;$ARGV[0],"code2"=&gt;join("\n",`xsel -o`)},
		"[http://tinypic.com/](http://tinypic.com/)"=&gt;{"the_file"=&gt;$ARGV[0]},	#Error GETing [http://tinypic.com/](http://tinypic.com/)
	);
foreach (keys %web){$add=$_,last if /$web_select/;}
if(!$add){$bus-&gt;Notify("paste-img", 0, "error", "无效网站地址", ":(", [], { }, -1);exit;}
print $web_select."\n";
#======================
$mech -&gt; get($add);
$mech -&gt; submit_form(with_fields =&gt; $web{$add});
#======================
if ($mech-&gt;success()) {
	my $rr=$mech-&gt;uri();
	print "贴图地址： $rr 。\n";
	`echo $rr|xsel -i`;
	$bus-&gt;Notify("paste-img", 0, "sunny", "贴图地址", $rr, [], { }, -1);
} else {
	$bus-&gt;Notify("paste-img", 0, "error", "贴图失败", ":(", [], { }, -1);
	print "ERROR:\t".$mech-&gt;status()."\n";
}
#======================