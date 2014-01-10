#!/usr/bin/perl

#use adb, access photos by date.
use Getopt::Long;
GetOptions('action=s' => \$action, "help"=>\$help);

if($help){
print <<STREND;
	use adb, access photos by date.
	default action is pull, default date is today.
	eg:
	$0 -a 'shell rm' 2000-01-01
	this will rm all sdcard/DCIM/100MEDIA/IMAG*.jpg with date by 2000-01-01.
STREND
exit;
}
#default action is pull
$action="pull" if ! $action;
#die "action:.$action.";

#default day is today
($day, $month, $year)=(localtime)[3,4,5];
$today=sprintf("%04d-%02d-%02d", $year+1900, $month+1, $day);
print "today: $today\n";

$_=shift;
if($_){
	/\d{4}-\d{2}-\d{2}/;
	if($& eq $_){
		$today=$_;
	}else{die "input date format: \\d{4}-\\d{2}-\\d{2}.\ndefault use today.\n"}
}
print "use: $today\n";

$dir='sdcard/DCIM/100MEDIA';
@_=map {s/.*\ //;$_} grep /$today/,`adb shell ls -l $dir/IMAG*`;
foreach(@_){
	chomp;
	print " $action -> $_.\n";
	`adb $action $dir/$_`;
}
