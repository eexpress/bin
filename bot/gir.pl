#!/usr/bin/perl
#
# girbot.pl
# Gir IRC Bot
# Author: Wraithnix (wraithnix@riotmod.com)
# Web: http://www.riotmod.com
#
use strict;
use Net::IRC;
use Switch;

#----------------------------------------------	
sub pc {
print "\e[1m\e[33m\e[44m $_[0] \e[0m\n";
}
sub pr {
print "\e[1m\e[33m\e[41m $_[0] \e[0m\n";
}
#----------------------------------------------	
use File::Basename qw/basename dirname/;

chdir dirname (-l $0?readlink $0:$0);
#----------------------------------------------	
# =============
# MAIN BOT CODE
# =============
#my @abc = ('a' .. 'z');
my $cfg_ident="eexp-bot";
my $cfg_port="8000";
my $cfg_server="irc.freenode.net";
#my $cfg_room="#eexpress";
my $cfg_room="#ubuntu-cn";
#----------------------------------------------	
my $ppp='\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';
my $ipv6='[\da-fA-F]{1,4}:[\da-fA-F]{1,4}:[\da-fA-F]{1,4}';
#my @Amynick=("iPhone","iFvwm","iGoogle","iGnome","iOpera","Oooops","eexp","eexpress");
my @Amynick=qw(iPhone iFvwm iGoogle iGnome iOpera Oooops eexp eexpress);
my @ACmd=qw(welcome voice http);
#my @ACmd=("welcome","voice","http");
my $voice=1;
my $welcome=1;
my $http=0;
my @botnick=@Amynick;
my $cfg_nick=shift @botnick;
#----------------------------------------------	
my $irc = new Net::IRC;
print "Creating connection to IRC server...";
my $conn = $irc->newconn(Server   => "$cfg_server",
             Port     => $cfg_port,
             Nick     => "$cfg_nick",
             Ircname  => "$cfg_ident",
             Username => "$cfg_ident")
    or die "Can't connect to IRC server.";
print "done!\n";

# connecting to the IRC server
sub on_connect {
    my $self = shift;
  print "*** Connected to IRC.\n";
	print "Joining $cfg_room ...\n";
	$self->join("${cfg_room}");
	$self->privmsg("${cfg_room}", "Ξ");

}
# This sub will print various
# incoming date while we're still
# connecting to IRC
sub on_init {
    my ($self, $event) = @_;
    my (@args) = ($event->args);
    shift (@args);

    print "*** @args\n";
}
# This sub will handle what happens when the
# bot receives public (channel) text.
sub on_public {
    my ($self, $event) = @_;
    my @to = $event->to;
    my ($nick, $mynick) = ($event->nick, $self->nick); # Sender text, 
#+Bot nick
    my $host=$event->host; # Sender's hostname
    my ($arg) = ($event->args); # The message
    
    # Here's where we want to "parse" channel text
#            print "<$nick> $arg\n";
#----------------------------------------------	
	if($nick=~$self->nick) {return 1;}	#自己的话
	if($voice==1){
	foreach (@Amynick){
	if($arg=~/\b$_\b/i){
	`aplay 2>/dev/null ~/bin/bot/default.wav`;
	last;}}}
#----------------------------------------------	
#        my ($c,@T)=split(/\s/,$arg);
#        my $w=join(" ",@T);
	my ($c,$w)=($arg=~/(\S+)(\s*.*)/);	# $w没匹配到，就$c也没内容
	if($c=~/^[?a-z]/){
	my @Afunc=(
	'?,echo t 字典 p 查IP库 ap 精确ip r 倒字 d 点字 h 花字 c 计算 y 荧光字 w 天气 u url转utf8 py 查拼音 bd 百度 bk 百科 deb 包信息 gt 中英互译 rss 新闻',
	't,sdcv.pl -1', 'p,ip-ip纯真库.pl', 'd,a-d点阵字.bash',
	'r,a-r倒字.bash', 'w,weather.pl -1', 'y,a-y荧光字贴图.bash', 
	'h,a-h花字.bash', 'u,url字串和utf8互转.pl', 'py,han-pinyin.pl', 'c,c',
	'bd,baidu.pl',	'bk,baike.pl,1',
	'deb,deb.pl', 'ap,apnic.pl',
	'gt,g-translate.pl', 'rss,rss.pl',
        );
	my @cc=grep(/^$c,/,@Afunc);
	if($cc[0]){
#        my $pid = fork();
#        unless ($pid){
#        if ($pid == 0 ){
#        if(!fork()){
		my @cmd=split ',',$cc[0];
		pc "cmd:\t <$cmd[1] $w>\n";
		my @send=`./$cmd[1] 2>/dev/null $w`;

		if($cmd[2]==1){$w=$nick;} else {$w=$cfg_room;}	#私聊?
		my $total=0;
		foreach (@send){	#多行输出
		$self->privmsg("$w", substr($_,0,240));
	#        if(length $_>200){
	#        $self->privmsg("$w", substr($_,240,));
	#        }
		$total++; last if($total>15);
		sleep 1 if(!$total%2);
		}
#        exit(0);
#        }
#        waitpid($pid, 0);
	}
	}
#----------------------------------------------	
	if($http==1){
	if($arg=~/http:\/\/\S*/){
	my $g=$&;
#        if ($g!~/\..{3,4}$/){	#.com.net.org?
	if($g!~/\<paste\./){
	if ($g!~/\.flv$|\.w..$|\.mp.{1,2}$|\.gz$|\.rar$|\.zip$|\.deb$|\.bz.$/)
	{
	my $t=`web-title.pl \'$g\'`;
#        my $r=`wget --no-cookies --no-follow-ftp \'$&\' -O -|enconv`;
#        w3m -no-cookie -dump_source http://www.lwpl.cn/|g title
#        $r=~/<title>(.*?)<\/title>/is;my $t=$&;$t=~s/<[^>]*>//g;
	$self->privmsg("${cfg_room}", "$g 网页标题：$t\n");
	}
	else{$self->privmsg("${cfg_room}", "$g 流媒体地址。\n");}
	}}
	}
#----------------------------------------------	
	if($arg=~s/.*知道(.+)吗.*/\1/){
#        $arg=~s/.*知道(.+)[吗?？]*/--\1--/;
#        print "解析0：=$&=\n";
	print "解析1：=$arg=\n";
	}
#----------------------------------------------	
}
# This sub will handle what happens when the
# bot receives private message text
sub on_join {
    my ($self, $event) = @_;
    my ($nick) = $event->nick; # Message Sender
#    my ($arg) = ($event->args); # Message Text
    my $host=$event->host;
    my $isknow=0;
#----------------------------------------------	
if(join(" ",@Amynick)=~$nick) {return 1;}	# 主人列表，忽略
#----------------------------------------------	
	my @Anick=(
	["roylez","金主席"],["GundamZZ","包包"],["bones7456","排骨"],
	["AutumnCat","球猫"],["iNutshell","栗子壳"],["manphiz","糖糖"],
	["freeflying","狒狒"],["iPeipei","佩佩朶"],["Arthrun","老雕"],
	["ShelyII","猞猁"],["lerosua","斗篷广"],["^k^","这猪猪bot"],
	["sunmoon1997","月月神教"],["palomino|working","破马"],
	["Epocher","洗脚"],["oneleaf","叶子"],["mOo","摸光"],
	["zhan","鲇鱼"],["GNUdog","狗狗"],["eXopeth","蜗牛"],
	["DawnFantasy","豆腐"],["Fong","赌棍"],["zmcbb30","包包"],
	["iDracaena","龙血妹"],["XwinX","叉叉老大"],
	);
	for my $i ( 0 .. $#Anick ){
	if($nick=~/^$Anick[$i][0]\d*\b/i){
	$nick=$Anick[$i][1]; $nick=~s/./&\&#1160;/g;
	$isknow=1; last;
	}
	}
#----------------------------------------------	
my $a="";
while($a eq ""){
	switch ($host) {
		case "59.36.101.19"	{$a="ubuntu-cn论坛的webirc"}
		case /^$ipv6.*/	{$a="太阳系v6"}
		case /^$ppp$/	{$a=`ip-ip纯真库.pl $host`}
		case /.*mibbit.*/	{$a="mibbit"}
		case m:/:	{$a="太阳系"}
		else{
		print "---------\n";
		while (my ($k,$v) = each %$event){print "- $k => $v\n";}
		$host=`host $host`;
		chomp($host);
		pc "- new host----$host";
		if($host=~/\b$ppp\b/){$host=$&;}
		else{$a="鬼搞鬼搞的地方";}
		}
	}
}
#----------------------------------------------	
	if($a=~"IANA"){$a="外太空";}
	chomp($a);
	print "$host==$a==\n";
	$_="欢迎来自 $a 的 $nick 加入 ubuntu 技术聊天室。《".$event->user."》\n";
	if(($welcome==1 and $isknow) or $welcome==2) {
	$self->privmsg("${cfg_room}", $_);}
	else{
	print $_;}
#----------------------------------------------	
}
sub on_msg {
    my ($self, $event) = @_;
    my ($nick) = $event->nick; # Message Sender
    my ($arg) = ($event->args); # Message Text
    my $host=$event->host;
    
    # Here's where we want to "parse" message text
#    print " - $nick -  $arg\n";
#----------------------------------------------	
if(join(" ",@Amynick)=~$nick){	# 主人列表，私聊命令
	my ($c,$w)=split(/\s/,$arg);
#        my ($c,$w)=($arg=~/(\S+)\s+(.*)/);
switch ($c){
	case "join" {$self->join("${cfg_room}");}
	case "nick" {$self->nick($w);}
	case "me" {$self->me("${cfg_room}",$w);}
	case "op" {$self->sl_real("PRIVMSG NickServ :IDENTIFY Oooops Oooops");}
	case "deop" {
	my $pl="PRIVMSG ChanServ :DEOP ".$cfg_room." ".$self->nick;
#        /msg ChanServ op #ubuntu-cn xxxx
	pc $pl;
	$self->sl_real($pl);
	}
	case "kick" {
	my $pl="KICK ".$cfg_room." ".$w." 冲撞bot";
	pc $pl;
	$self->sl_real($pl);
	}
	case "ctcp" {$arg=~s/.*?\s//;pc $arg;$self->ctcp(split(/\s/,$arg,3));}
#        /msg iPhone ctcp ACTION #ubuntu-cn xxxx
	case "sl" {$arg=~s/.*?\s//;pc $arg;$self->sl($arg);}	# NICK xxx ok. ctcp fault test.
#        /msg iPhone sl NICK xxxx
#        /msg iPhone sl PRIVMSG NickServ :IDENTIFY Oooops Oooops
#        /msg iPhone sl PRIVMSG ChanServ :deop #ubuntu-cn iPhone
#        /msg iPhone sl KICK ubuntu-cn xxxx
#        case "w" {my @r=$self->sl_real("WHOIS ".$w);print "== whois $w = @r =\n";}
	case "w" {
		pr $self->sl_real("USERHOST ".$w)." !!\n";
#                pr $self->whois($w)." xx\n";
#                pr "== userhost $w = $r =\n"; print "$r\n";
		}
	case "help" {pc join(",",@ACmd);}
	case "eval" {$arg=~s/.*?\s//;$self->privmsg("$nick","运行结果：".eval("$arg"));}
	case (\@ACmd) {
		my $cmd;
#                if($w eq "on"){$cmd="$c=1";}else{$cmd="$c=0";}
		$cmd="$c=$w";
		eval "\$$cmd";
		$self->privmsg("${cfg_room}", "Yes, Sir. $cmd\n");
		$cmd="pc \"----$c=\$$c----\t\"";
		eval "$cmd";
#                while (my ($k,$v) = each %$self){print "- $k => $v\n";}
#                last;
	}
	else {$self->privmsg("${cfg_room}", "$arg\n");}
}
}
#----------------------------------------------	
else {
$self->privmsg("${cfg_room}", "$nick: 别私聊。不告诉你，气死你。 :D \n");
}
#----------------------------------------------	
}
# This sub will get triggered if our bot's nick
# is taken, setting it to our alternate nick.
sub on_nick_taken {
    my ($self) = shift;
	$self->nick(shift @botnick);
}
#----------------------------------------------	
# Now that all of our handler subs are created,
# let's install them
print "Installing local handlers...";
$conn->add_handler('public', \&on_public);
$conn->add_handler('msg',    \&on_msg);
$conn->add_handler('join',    \&on_join);
print "done!\nInstalling global handlers...";
$conn->add_global_handler([ 251,252,253,254,302,255 ], \&on_init);
$conn->add_global_handler(376, \&on_connect);
$conn->add_global_handler(433, \&on_nick_taken);
print "done!\n";
# Everything's installed, so there's nothing
# holding up back from starting up!
$irc->start;

