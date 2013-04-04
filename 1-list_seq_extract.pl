use strict;
use warnings;

my $genomefile = shift;
my $genelist = shift;
my $outfile = shift;

if(!defined($outfile)) {
	die "USAGE: perl $0 1-genomefile 2-list_geneids 3-outfile\n";
}


# ==========
# = Banner =
# ==========

open INFILE, "$genomefile" or die "error in opening $genomefile\n";


my $seq = "";
my ($line, $seqid, $len);
my %telemereHash;


while($line = <INFILE>) {
	
	chomp $line;
	
	# ^>.*(chromosome\s\d{1,2})
	if ($line =~/^>(.*)\s/) {
	# if ($line =~/^>(.*)/) {
		
		if($seq ne "") {
			$len = length($seq);
		}
		
		$seqid = $1;
		$seq = "";
		
	} else {
		$seq .= $line;
		$telemereHash{$seqid}{seq} = $seq;
	}	
}



close INFILE;


# =====================
# = Read in gene list =
# =====================

my $extract;

open GENELIST, "$genelist" or die "error in opening $genelist\n";
open OUTFILE, ">$outfile" or die "Error in opening $outfile\n";

while($line = <GENELIST>) {
	
	chomp $line;
	
	if (exists $telemereHash{$line}) {
		$extract = $telemereHash{$line}{seq};
		print OUTFILE ">$line\n$extract\n";
	}
}


close OUTFILE;
close GENELIST;


exit;