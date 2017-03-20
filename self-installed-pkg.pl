#!/usr/bin/perl

my $Bred="\e[1;31m"; my $Bblue="\e[1;34m"; my $normal="\e[0m";

$_=`less /var/log/apt/history.log*`;
s/Start-Date: //g;
s/(Commandline:|Requested-By:|Upgrade:|End-Date:).*//g;
s/\(.*?\)//g; 
$apt=$_;

open IN,"</var/log/aptitude";
$aptitude="";
$last="";
while(<IN>){
	if(/(\s..:..:..\s|\[卸载|\[REMOVE|\[INSTALL|\[安装)/){
		s/(:amd64|:i386)\s.*/$1/;
		s/(\[卸载|\[REMOVE).*\]/Remove:/;
		s/(\[INSTALL|\[安装).*\]/Install:/;
		if(/..:..:../){
			@datetime=split /\s+/;
			$datetime[1]=~/\d+/; $_=sprintf "%02d",$&;
			$aptitude.="$datetime[3]-$_-$datetime[2] $datetime[4]\n";
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
#print;

@re=split /\n/;
@pkg=();
@del=();
for(sort @re){
	if(/(Install:|Remove:)/){
		$act=$&;
		for(split /,/,$'){
			s/\ //g;
			next if (/^\s*$/);
#            print "$act => $_\n";
			$k=$_;
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
print "-------------$Bblue pkg installed $normal------------\n";
for(@pkg){print "$_\t";} print "\n";
print "-------------$Bred pkg deleted $normal------------\n";
for(@del){print "$_\t";} print "\n";

