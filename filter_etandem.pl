use strict;
use warnings;


my $etandem = shift;
my $outfile = shift;

# purpose is to go through all the etandem output files and see if there were any hits, if there were hits then compile them into one output file.

if (!defined($outfile)) {
	die "USAGE: perl $0 1-output.etandem 2-outfile\n";
}
	


# Open and read each one of the etandem files that were just created


my ($line, $readid, $hitcount);


open INFILE, "$etandem" or die "error in opening $etandem\n";
open OUTFILE, ">>$outfile" or die "error in opening $outfile\n";

# skip the first 14 lines
$line = <INFILE>;
$line = <INFILE>;
$line = <INFILE>;
$line = <INFILE>;
$line = <INFILE>;
$line = <INFILE>;
$line = <INFILE>;
$line = <INFILE>;
$line = <INFILE>;
$line = <INFILE>;
$line = <INFILE>;
$line = <INFILE>;
$line = <INFILE>;
$line = <INFILE>;


while($line = <INFILE>) {
	
	chomp $line;
  
	# pull out the read ID
  if($line =~ /.*Sequence\:\s(\S*)\s.*/) {
    $readid = $1;
    next;
	}

  # if there are any hits print them to the outfile 
  if($line =~ /.*HitCount\:\s(.?)/) {
    $hitcount = $1;
    if ($hitcount == 0) {
      last;
      } else {
        $line = <INFILE>;
        $line = <INFILE>;
        $line = <INFILE>;
        $line = <INFILE>;
        $line = <INFILE>;
        $line = <INFILE>;
        $line = <INFILE>;
        $line = <INFILE>;
        $line = <INFILE>;
        $line = <INFILE>;
        $line = <INFILE>;
      } 
  }
  if ($line =~ /\w/) {
    print OUTFILE "$readid\t$line\n";
    } else {
      last;
   }
}



close INFILE;
close OUTFILE;

exit;



