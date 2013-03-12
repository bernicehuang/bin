#!/usr/bin/env perl

# gets a rpsblast results file and a hash with CDD ID (key) and type/description (value)
# and outputs gene ID and COG classification

use strict;
use warnings;
use DB_File;

open(BLA, "<$ARGV[0]") or die "Could not open rpsblast results file $ARGV[0]: $!\n";

my %desc;
my $withEV = 1;
tie(%desc, "DB_File", "$ARGV[1]") or die "Could not open hash $ARGV[1]: $!\n";

while(<BLA>) {
 chomp;
 my @tmp = split;
 my @cdd = split(/\|/, $tmp[1]);
 if(exists $desc{$cdd[2]}) { 
   unless($withEV) { print "$tmp[0]\t$desc{$cdd[2]}\n"; }
       else { print "$tmp[0]\t$desc{$cdd[2]}\t$tmp[10]\n"; }
 }
}

exit;
