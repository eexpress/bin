#!/usr/bin/perl
use Encode;
#http://www.herongyang.com/2010/2010_chinese_calendar_gb.html
if($ARGV[0]!~/2\d\d\d/){die "parameter need year format, like 2012;"}
if(! -f "$ARGV[0]_chinese_calendar_gb.html"){
`wget http://www.herongyang.com/$ARGV[0]/$ARGV[0]_chinese_calendar_gb.html`;
}
open (HTML,"$ARGV[0]_chinese_calendar_gb.html")||die "没有找到农历html文件。";
@l=<HTML>; close HTML;
open(CAL,">calendar.$ARGV[0].lunar");

print CAL "#ifndef _calendar_lunar
#define _calendar_lunar

LANG=utf-8

";

@l=map m:(<td.*?\d.*?/td>):,@l;
map {s/<br\/>/_/g;s/<.*?>//g;push @l;} @l;
foreach(<@l>){
        chomp;
        if(! /_/){$month=$_;}
        else{s/_/\t/g;
        $_=decode("GBK", $_);$_=encode("UTF-8", $_);
        print CAL "$month/$_\n";}
}
print CAL "\n#endif\n";
close CAL;

