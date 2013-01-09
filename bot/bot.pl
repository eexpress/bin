#!/usr/bin/perl
# eexpress perl bot

use feature qw(switch say);
use strict;
use Net::IRC;
use File::Basename qw/basename dirname/;
use Encode qw(_utf8_on _utf8_off);

#----------------------------------------------	
my @FuncDef=(
	't,字典,sdcv.pl -1,p',
	'p,查询IP,ip-138.bash,p',
	'd,点阵字,a-d点阵字.bash,p',
	'r,倒字,a-r倒字.bash,p',
	'x,花字,a-h花字.bash,p',
	'bk,百科,baike.pl,p',
	'deb,软件包信息,deb.pl,p',
	'ap,精确ip查询,apnic.pl,p',
	'rss,新闻订阅,rss.pl,p',
	);
#----------------------------------------------	
chdir dirname (-l $0?readlink $0:$0);

my @ACmd=qw(welcome http);
my $welcome=1;
my $http=0;

my @Amynick=qw(iFvwm iGoogle iGnome iOpera Oooops eexp eexpress);
my @botnick=@Amynick;
my $cfg_nick=shift @botnick;
my $cfg_room="#ubuntu-cn";
$cfg_room=$ARGV[0] if($ARGV[0]);
if($cfg_room!~/^#/){$cfg_room="#".$cfg_room;}

my $irc = new Net::IRC;
print "Creating connection to IRC server...";
my $conn = $irc->newconn(Server   => "irc.freenode.net",
             Port     => 8000,
             Nick     => "$cfg_nick",
             Ircname  => "eexp-bot",
             Username => "eexp-bot")
    or die "Can't connect to IRC server.";
say "done!";

print "Installing local handlers...";
$conn->add_handler('public', \&on_public);
$conn->add_handler('msg',    \&on_msg);
$conn->add_handler('join',    \&on_join);
$conn->add_handler('kick',    \&on_kick);
print "done!\nInstalling global handlers...";
$conn->add_global_handler([ 251,252,253,254,302,255 ], \&on_init);
$conn->add_global_handler(376, \&on_connect);
$conn->add_global_handler(433, \&on_nick_taken);
say "done!";
$irc->start;
#----------------------------------------------	
sub pc {
say "\e[1m\e[33m\e[44m $_[0] \e[0m";
}
#----------------------------------------------	
sub on_connect {
	my $self = shift;
	say "*** Connected to IRC.";
	say "*** Joining $cfg_room ...";
	$self->join("$cfg_room");
	$self->privmsg("$cfg_room", "Ξ");
	pc "Enter $cfg_room";
}
#----------------------------------------------	
sub on_init {
	my ($self, $event) = @_;
	my (@args) = ($event->args);
	shift (@args);
	say "*** @args";
}
#----------------------------------------------	
sub on_public {
    my ($self, $event) = @_;
    my @to = $event->to;
    my ($nick, $mynick) = ($event->nick, $self->nick);
    my $host=$event->host;
    my ($arg) = ($event->args);
    
	if($nick=~$self->nick) {return 1;}	# bot自己的话
	# 提到主人的信息，提示声音
	foreach (@Amynick){if($arg=~/\b$_\b/i){`aplay 2>/dev/null default.wav`;last;}}
	if($arg=~/^-h/){$arg="帮助： ";{foreach(@FuncDef){my @info=split ','; $arg.="-$info[0] $info[1], ";}} $self->privmsg("$cfg_room",$arg); return 1;}
	if($arg=~/^-/){		# 命令以-开始
		$arg=~s/^-//;
#        my ($c,@T)=split(/\s/,$arg); # $w没匹配到，就$c也没内容
		my ($c,$w)=($arg=~/(\S+)(\s*.*)/);
		if($w=~/[\|`><\$()\/]/){
#            if(@Amynick ~~ $nick)
			if(join(" ",@Amynick)=~/\b$nick\b/){$self->privmsg($cfg_room,"发现非法字符");}
			else{$self->privmsg($nick,"死家伙，用命令的都踢了。");}
		}
		else{
			my @cc=grep(/^$c,/,@FuncDef);
			if($cc[0]){
				my @cmd=split ',',$cc[0];
				pc "cmd:\t <$cmd[2] $w>";
				my @send=`./$cmd[2] 2>/dev/null $w`;

				if($cmd[3]=~/m/){$w=$nick;} else {$w=$cfg_room;}	#私聊?
				my $total=0;
				$_=join ' ',@send; _utf8_on($_); @_=/.{1,140}/g;
				foreach(@_){
					_utf8_off($_); $self->privmsg("$w",$_);
					$total++;last if($total>3);}
			}
		}
	}

	if($http==1){
	if($arg=~/http:\/\/\S*/){
		my $g=$&;
		if($g!~/\<paste\./){
		if ($g!~/\.flv$|\.w..$|\.mp.{1,2}$|\.gz$|\.rar$|\.zip$|\.deb$|\.bz.$/){
			pc "url:\tweb-title.pl \'$g\'";
			my $t=`./web-title.pl \'$g\'`;
			$self->privmsg("$cfg_room", "$g 网页标题：$t\n");
		}}}}
}
#----------------------------------------------	
sub on_join {
	my ($self, $event) = @_;
	my ($nick) = $event->nick;
	my ($arg) = ($event->args);
	my $isknow=0;

#    if(@Amynick ~~ $nick) {return 1;}	# 主人列表，忽略
	if(join(" ",@Amynick)=~/\b$nick\b/) {return 1;}       # 主人列表，忽略

	my @Anick=(
	["roylez","金主席"],["GundamZZ","包包"],["bones7456","排骨"],
	["AutumnCat","球猫"],["iNutshell","栗子壳"],["manphiz","糖糖"],
	["freeflying","狒狒"],["iPeipei","佩佩朶"],["Arthrun","老雕"],
	["ShelyII","猞猁"],["lerosua","斗篷"],["^k^","这猪猪bot"],
	["sunmoon1997","月月"],["palomino|working","破马"],
	["Epocher","洗脚"],["oneleaf","叶子"],["mOo","摸光"],
	["zhan","鲇鱼"],["GNUdog","狗狗"],["eXopeth","蜗牛"],
	["DawnFantasy","豆腐"],["Fong","赌棍"],["zmcbb30","包包"],
	["iDracaena","龙血妹"],["XwinX","叉叉"],["cfy","浮云"],["bye_bye","掰掰"],
	["MeaCulpa","酷胖"],["gfrog","噶嘛"],["hamo","蛤蟆"],["adam8157","蛋蛋"],
	["jiero","罗杰"],["micaocai","微菜"],["tenzu","疼疼"],["huntxu","嘘嘘"],
	["ofan","呕饭"],["bluezd","不撸"],["archl","杰杰"],
#    ["",""],["",""],["",""],
#    ["",""],["",""],["",""],["",""],["",""],
	);
	for my $i ( 0 .. $#Anick ){
		if($nick=~/^$Anick[$i][0]\d*\b/i){
			$nick=$Anick[$i][1];
			$isknow=1; last;
		}
	}
#--------------------
	my $ipv4='\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';
	my $ipv6='[\da-fA-F]{1,4}:[\da-fA-F]{1,4}';
	my $host=$event->host;
	say $host;
	$host=~s/(\d)-(\d)/$1.$2/g;		#42-65-57-75.dynamic-ip.hinet.net
	my @Aip=(
			["unaffiliated","太阳系"],["redhat","帽帽"],["mibbit","mibbit"],
			["${ipv6}","外太空"],["59.36.101.19","论坛"],["wikipedia","维基"],
			);
	my $add="";
	if($host=~/\b${ipv4}\b/){$add=`w3m -dump -no-cookie 'http://www.ip138.com/ips138.asp?ip=$host&action=2'|grep  本站主数据`;$add=~s/.*：//;chomp $add;}
	else{
		for my $i ( 0 .. $#Aip ){
			if($host=~/$Aip[$i][0]/){ $add=$Aip[$i][1]; last; }
		}
		$add="鬼搞鬼搞的地方" if $add eq "";
	}
	$_="欢迎来自 $add 的 $nick 加入聊天室。《 ".$event->user." 》";
	pc $_;
	if(($welcome==1 and $isknow) or $welcome==2){$self->privmsg("$cfg_room", $_);}
}
#----------------------------------------------	
sub on_msg {
    my ($self, $event) = @_;
    my ($nick) = $event->nick;
    my ($arg) = ($event->args);
    my $host=$event->host;

#if(@Amynick ~~ $nick){	# 主人列表，私聊命令
if(join(" ",@Amynick)=~/\b$nick\b/){ # 主人列表，私聊命令
	my ($c,$w)=split(/\s/,$arg);
	given ($c){
		when ("join") {$self->join("$cfg_room");}
		when ("nick") {$self->nick($w);}
		when ("me") {$self->me("$cfg_room",$w);}
		when ("op") {$self->sl_real("PRIVMSG NickServ :IDENTIFY Oooops $w");}
		when ("deop") {$self->sl_real("PRIVMSG ChanServ :DEOP ".$cfg_room." ".($w eq ""?$self->nick:$w));}
		when ("kick") {$self->sl_real("KICK ".$cfg_room." ".$w." 冲撞bot") if(join(" ",@Amynick)!~/\b$w\b/);}
		when ("eval") {$arg=~s/.*?\s//;$self->privmsg("$nick","$arg 运行结果：".(eval "$arg"));}
		when (\@ACmd) {
			my $cmd;
			if($w eq ""){$self->privmsg("$nick", "Now $c is ".(print $c).", Sir.");}
			else{
				$cmd="$c=$w"; eval "$cmd";
				$self->privmsg("$nick", "Yes, Sir. $cmd\n");
			}
		}
		default {$self->privmsg("$nick", "My Lord, Parameter: welcome=".(print $welcome)." http=".(print $http)."; Commands: join nick me op deop kick eval\n"); $nick="x";}
	}
	pc "$nick -> $arg" if $nick ne "x";
}
else {$self->privmsg("$nick", "别私聊。不告诉你，气死你。 :D \n");}
#else {$self->privmsg("$cfg_room", "$nick: 别私聊。不告诉你，气死你。 :D \n");}
}
#----------------------------------------------	
sub on_nick_taken {
	my ($self) = shift;
	$self->nick(shift @botnick);
}
#----------------------------------------------	
sub on_kick {
	my ($self, $event) = @_;
    my ($nick) = $event->nick;
	$self->join("$cfg_room");
	$self->privmsg("$cfg_room", "谁那么无聊啊。nnnnnd $nick 你又咋了。");
}
#----------------------------------------------	

