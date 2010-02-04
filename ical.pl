#!/usr/bin/perl
use Tie::iCal;

tie %events, 'Tie::iCal', "$ARGV[0]" or die "Failed to tie file!\n";
print "#ifndef _calendar_ics_convert\n#define _calendar_ics_convert\n\nLANG=utf-8\n\n";

my @items = map { $events{$_}->[1] } keys(%events);
untie(%events);

@items = sort { $a->{'DTSTART'}->[1] cmp $b->{'DTSTART'}->[1] } @items;
foreach my $item (@items) {
#$item->{'SUMMARY'}=~s/\s.*//;
my $date=$item->{'DTSTART'}->[1];
$date=~/(\d{4})(\d{2})(\d{2})/;
$date="$2/$3";
print $date."\t".$item->{'SUMMARY'}.", $1\n";
}
print "\n#endif\n";
