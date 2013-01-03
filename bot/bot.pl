#!/usr/bin/perl
# eexpress perl bot

use strict;
use Net::IRC;
use Switch;
use File::Basename qw/basename dirname/;

#----------------------------------------------	
my @FuncDef=(
	't,字典,sdcv.pl -1,p',
	'p,查询IP,ip-138.bash,p',
	'd,点阵字,a-d点阵字.bash,p',
	'r,倒字,a-r倒字.bash,p',
	'x,花字,a-h花字.bash,p',
	'bd,百度,baidu.pl,m',
	'bk,百科,baike.pl,m',
	'deb,软件包信息,deb.pl,p',
	'ap,精确ip查询,apnic.pl,p',
	'rss,新闻订阅,rss.pl,p',
	);
#----------------------------------------------	
chdir dirname (-l $0?readlink $0:$0);
my $ipv4='\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';
my $ipv6='[\da-fA-F]{1,4}:[\da-fA-F]{1,4}:[\da-fA-F]{1,4}';

my @ACmd=qw(welcome http);
my $welcome=1;
my $http=0;

my @Amynick=qw(iFvwm iGoogle iGnome iOpera Oooops eexp eexpress);
my @botnick=@Amynick;
my $cfg_nick=shift @botnick;
my $cfg_room="#ubuntu-cn";
my $cfg_room="#eexpress";

my $irc = new Net::IRC;
print "Creating connection to IRC server...";
my $conn = $irc->newconn(Server   => "irc.freenode.net",
             Port     => 8000,
             Nick     => "$cfg_nick",
             Ircname  => "eexp-bot",
             Username => "eexp-bot")
    or die "Can't connect to IRC server.";
print "done!\n";

print "Installing local handlers...";
$conn->add_handler('public', \&on_public);
$conn->add_handler('msg',    \&on_msg);
$conn->add_handler('join',    \&on_join);
print "done!\nInstalling global handlers...";
$conn->add_global_handler([ 251,252,253,254,302,255 ], \&on_init);
$conn->add_global_handler(376, \&on_connect);
$conn->add_global_handler(433, \&on_nick_taken);
print "done!\n";
$irc->start;
#----------------------------------------------	
sub pc {
print "\e[1m\e[33m\e[44m $_[0] \e[0m\n";
}
#----------------------------------------------	
sub on_connect {
	my $self = shift;
	print "*** Connected to IRC.\n";
	print "*** Joining $cfg_room ...\n";
	$self->join("${cfg_room}");
	$self->privmsg("${cfg_room}", "Ξ");
}
#----------------------------------------------	
sub on_init {
	my ($self, $event) = @_;
	my (@args) = ($event->args);
	shift (@args);
	print "*** @args\n";
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
		my @cc=grep(/^$c,/,@FuncDef);
		if($cc[0]){
			my @cmd=split ',',$cc[0];
			pc "cmd:\t <$cmd[2] $w>\n";
			my @send=`./$cmd[2] 2>/dev/null $w`;

			if($cmd[3]=~/m/){$w=$nick;} else {$w=$cfg_room;}	#私聊?
			my $total=0;
			foreach (@send){	#多行输出
			$self->privmsg("$w", substr($_,0,240));
			$total++; last if($total>15);
			sleep 1 if(!$total%2);
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
			$self->privmsg("${cfg_room}", "$g 网页标题：$t\n");
		}}}}
}
#----------------------------------------------	
sub on_join {
	my ($self, $event) = @_;
	my ($nick) = $event->nick;
	my ($arg) = ($event->args);
	my $host=$event->host;
	my $isknow=0;

	if(join(" ",@Amynick)=~$nick) {return 1;}	# 主人列表，忽略

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
my $a="";
while($a eq ""){
	switch ($host) {
		case "59.36.101.19"	{$a="ubuntu-cn论坛的webirc"}
		case /^${ipv6}.*/	{$a="太阳系v6"}
		case /^${ipv4}$/	{$a=`./ip-138.bash $host`}
		case /.*mibbit.*/	{$a="mibbit"}
		case m:/:	{$a="太阳系"}
		else{
		print "---------\n";
		while (my ($k,$v) = each %$event){print "- $k => $v\n";}
		$host=`host $host`;
		chomp($host);
		pc "- new host----$host";
		if($host=~/\b${ipv4}\b/){$host=$&;}
		else{$a="鬼搞鬼搞的地方";}
		}
	}
}
	if($a=~"IANA"){$a="外太空";}
	chomp($a);
	print "$host==$a==\n";
	$_="欢迎来自 $a 的 $nick 加入聊天室。《".$event->user."》\n";
	if(($welcome==1 and $isknow) or $welcome==2) {
	$self->privmsg("${cfg_room}", $_);}
	else{
	print $_;}
}
#----------------------------------------------	
sub on_msg {
    my ($self, $event) = @_;
    my ($nick) = $event->nick;
    my ($arg) = ($event->args);
    my $host=$event->host;
    
if(join(" ",@Amynick)=~$nick){	# 主人列表，私聊命令
	my ($c,$w)=split(/\s/,$arg);
	switch ($c){
		case "join" {$self->join("${cfg_room}");}
		case "nick" {$self->nick($w);}
		case "me" {$self->me("${cfg_room}",$w);}
		case "op" {$self->sl_real("PRIVMSG NickServ :IDENTIFY Oooops Oooops");}
		case "deop" {$self->sl_real("PRIVMSG ChanServ :DEOP ".$cfg_room." ".$self->nick);}
		case "kick" {$self->sl_real("KICK ".$cfg_room." ".$w." 冲撞bot");}
		case "eval" {$arg=~s/.*?\s//;$self->privmsg("$nick","运行结果：".eval("$arg"));}
		case (\@ACmd) {
			my $cmd;
			$cmd="$c=$w";
			eval "\$$cmd";
			$self->privmsg("$nick", "Yes, Sir. $cmd\n");
			eval "$cmd";
		}
		else {$self->privmsg("$nick", "My Lord, all commands list: ".join(" ",@ACmd)." join nick me op deop kick eval\n");}
	}
}
else {$self->privmsg("${cfg_room}", "$nick: 别私聊。不告诉你，气死你。 :D \n");}
}
#----------------------------------------------	
sub on_nick_taken {
	my ($self) = shift;
	$self->nick(shift @botnick);
}
#----------------------------------------------	

