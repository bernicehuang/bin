use strict;
use warnings;

my $sizefile = shift;
my $etandem = shift;
my $outfile = shift;

# purpose is to go through all the etandem output files and see if there were any hits, if there were hits then compile them into one output file.

if (!defined($outfile)) {
	die "USAGE: perl $0 1-size-file 2-output.etandem 3-outfile\n";
}
	

# =======================================
# = Read in the Contig/Gene.sizes files =
# =======================================
# this is the output file from the mfsizes script. There should be 4 columns, with the 1st column being either the contig ID or geneID. 

open SIZEFILE, "$sizefile" or die "error in opening $sizefile\n";


my @cols;
my ($line, $seqname, $size, $gc, $numofn);
my %sizeHash;

# ignore the first 15 lines.
$line = <SIZEFILE>;
$line = <SIZEFILE>;
$line = <SIZEFILE>;
$line = <SIZEFILE>;
$line = <SIZEFILE>;
$line = <SIZEFILE>;
$line = <SIZEFILE>;
$line = <SIZEFILE>;
$line = <SIZEFILE>;
$line = <SIZEFILE>;
$line = <SIZEFILE>;
$line = <SIZEFILE>;
$line = <SIZEFILE>;
$line = <SIZEFILE>;
$line = <SIZEFILE>;

while($line = <SIZEFILE>) {
	
	chomp $line;
	
	@cols = split(/\t/, $line);
	$seqname = $cols[0];
	$size = $cols[1];
	$gc = $cols[2];
	$numofn = $cols[3];
	
	$sizeHash{$seqname}{size} = $size;
	$sizeHash{$seqname}{gc} = $gc;
	$sizeHash{$seqname}{numofn} = $numofn;
}

close SIZEFILE;






my ($readid, $hitcount, $extract_size, $extract_gc, $extract_numofn);


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
	
		if (exists $sizeHash{$readid}) {
			$extract_size = $sizeHash{$readid}{size};
			$extract_gc = $sizeHash{$readid}{gc};
			$extract_numofn = $sizeHash{$readid}{numofn};
    } 
	}
	next;
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
    print OUTFILE "$readid\t$line\t$extract_size\t$extract_gc\t$extract_numofn\n";
    } else {
      last;
   }
}



close INFILE;
close OUTFILE;

exit;



