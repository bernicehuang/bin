use strict;
use warnings;

my $etandem = shift;
my $outfile = shift;


if(!defined($outfile)) {
	die "USAGE: perl $0 1-etandemfile 2-outfile\n";
}


my @etandemarray;


if(-d $etandem) {
	@etandemarray = <$etandem/*.etandem>;
} elsif(-f $etandem && $etandem =~/\.etandem$/) {
	push @etandemarray, $etandem;
}

# declare variables
my ($etandemfile, $command);

foreach $etandemfile (@etandemarray) {
	print "File = $etandemfile\n";
	
  # run script to see if there were any repeats detected in the sequence
  $command = "perl ~/bin/filter_etandem.pl $etandemfile $outfile";
    `$command`;
    
}



exit; 




# ==================================
# = subroutine to run unix command =
# ==================================

sub runSystemCommand {
	my $cmd = shift;
	print "CMD = $cmd\n";
	`$cmd`;
}




