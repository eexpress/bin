#!/usr/bin/perl

use Tie::iCal;
tie %events, 'Tie::iCal', "$ARGV[0]" or die "Failed to tie file!
";
print "#ifndef _calendar_ics_convert
#define _calendar_ics_convert

LANG=utf-8

";
my @items = map { $events{$_}->[1] } keys(%events);
untie(%events);
@items = sort { $a->{'DTSTART'}->[1] cmp $b->{'DTSTART'}->[1] } @items;
foreach my $item (@items) {
my $date=$item->{'DTSTART'}->[1];
$date=~/(\d{4})(\d{2})(\d{2})/;
$date="$2/$3";
print $date."	".$item->{'SUMMARY'}.", $1
";
}
print "
#endif
";

