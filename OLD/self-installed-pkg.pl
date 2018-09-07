#!/usr/bin/perl

my $Bred="\e[1;31m"; my $Bblue="\e[1;34m"; my $normal="\e[0m";

#$debug_pkg="chrome-gnome-shell";
$debug_pkg="";
$_=`less /var/log/apt/history.log*`;
s/Start-Date: //g;
s/(Commandline:|Requested-By:|Upgrade:|End-Date:).*//g;
s/\(.*?\)//g; 
s/(-\d\d)\s+(\d\d:)/$1_$2/g;
#sometime Remove follow by Purge
s/(Remove:[^\n]*)\nPurge:/$1,/sg;
$apt=$_;
#reduce depend pkg in list mode, will cause "pkg deleted" error
#s/(Reinstall:|--reinstall|Requested-By:|Upgrade:|End-Date:).*//g;
#s/Commandline: apt(daemon| autoremove| upgrade| purge).*//g;
#s/\(.*?\)//g;
#@re=split /\n/;
#$i=0;
#while($i < @re){
#    $_=$re[$i]; $i++;
#    next if (/^\s*$/);
#    if(!/Commandline:/){$apt.="$_\n";next};
#    s/^.*\ install//;
#    s/^\s*//;
#    @_=split /\ +/;
#    $_=$re[$i]; $i++;
#    while(/^\s*$/){$_=$re[$i]; $i++;}
#    $apt.="Install: ";
#    $k=$_;
#    for(@_){
#    $k=~/$_:[^\s]+/; $apt.="$&,";
#    }
#    chop $apt;
#    $apt.="\n";
#}
#print; exit;

open IN,"</var/log/aptitude";
$aptitude="";
$last="";
@month=("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
while(<IN>){
	if(/(\s..:..:..\s|\[卸载|\[REMOVE|\[INSTALL|\[安装)/){
#    if(/(\s..:..:..\s|\[卸载\]|\[REMOVE\]|\[INSTALL\]|\[安装\])/){
		s/(:amd64|:i386)\s.*/$1/;
		s/(\[卸载|\[REMOVE).*\]/Remove:/;
		s/(\[INSTALL|\[安装).*\]/Install:/;
		if(/..:..:../){
			@datetime=split /\s+/;
#detect month
			if(grep /$datetime[1]/,@month){
				$m=0;
				while($m<@month){
					if($datetime[1]==$month[$m]){
						last;
					}
				}
				$_=sprintf "%02d",$m+1;
			}else{
				$datetime[1]=~/\d+/; $_=sprintf "%02d",$&;
			}
			$aptitude.="$datetime[3]-$_-$datetime[2]_$datetime[4]\n";
			$last="T";
		}else{
			if($last eq "T"){$aptitude.=$_;}
			else{
				s/^.*?:/,/;
				chomp $aptitude;
				$aptitude.=$_;
			}
			$last="X";
		}

	}
}
close IN;
$_="$apt\n$aptitude";
s/(20..-..-.*)\s*([^\d])/$1 $2/g;
s/^[\d-:\s]*$//mg; s/\n+/\n/g;
#print; exit;

@re=split /\n/;
@pkg=();
@del=();
for(sort @re){
	if(/(Install:|Remove:|Purge:)/){
		$line=$_;
		$act=$&;
		for(split /,/,$'){
			s/\ //g;
			next if (/^\s*$/);
#not care pkg.
			next if (/(^lib|^linux-|^xserver-xorg)/);
#            print "$act => $_\n";
			$k=$_;
			if($k=~/$debug_pkg/){
				$line=~s/($debug_pkg)/$Bred$1$normal/;
				$line=~s/(20..-[-\d:\s_]*)/$Bblue$1$normal/;
				print $line."\n";}
			if($act=~/Install:/){
				push @pkg,$k if ! grep /$k/,@pkg;
				@del=grep !/$k/, @del;
			}
			else{
				push @del,$k if ! grep /$k/,@del;
				@pkg=grep !/$k/, @pkg;
			}
		}
	}
}
if($debug_pkg ne ""){exit;}

print "-------------$Bblue pkg installed $normal------------\n";
$list="";
for(@pkg){s/:amd64//;s/:i386//;$list.="$_\ ";} $list.="\n";
print $list;
print "-------------$Bred verify deviation $normal------------\n";
chomp $list; print `apt list $list|grep -v 安装`;

print "-------------$Bred pkg deleted $normal------------\n";
$list="";
#Due to remove depend pkgs, this list some error.
for(@del){s/:amd64//;s/:i386//;$list.="$_\ ";} $list.="\n";
print $list;
print "-------------$Bred verify deviation $normal------------\n";
chomp $list; print `apt list $list|grep 安装`;
