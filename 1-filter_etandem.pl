use strict;
use warnings;

my $sizefile = shift;
my $etandem = shift;
my $outfile = shift;


if(!defined($outfile)) {
	die "USAGE: perl $0 1-sizefile 2-etandemfile 3-outfile\n";
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
  $command = "perl filter_etandem.pl $sizefile $etandemfile $outfile";
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




