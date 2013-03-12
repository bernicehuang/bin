use strict;
use warnings;


my $genelist = shift;
my $sizefile = shift;
my $outfile = shift;


if(!defined($outfile)) {
	die "USAGE: perl $0 1-list-gene/contig-id 2-gene/contig.sizes 3-outfile\n";
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




# =====================
# = Read in gene list and extract contig id=
# =====================

# ===================================
# = Read in gene/contig list of IDs =
# ===================================
# This should just be a list with either gene or contig ID's in it. '

my $extract_size;
my $extract_gc;
my $extract_numofn;


open GENELIST, "$genelist" or die "error in opening $genelist\n";
open OUTFILE, ">$outfile" or die "Error in opening $outfile\n";



while($line = <GENELIST>) {
	
	chomp $line;
	
	if (exists $sizeHash{$line}) {
		$extract_size = $sizeHash{$line}{size};
		$extract_gc = $sizeHash{$line}{gc};
		$extract_numofn = $sizeHash{$line}{numofn};
		
		print OUTFILE "$line\t$extract_size\t$extract_gc\t$extract_numofn\n";
	}
}

close GENELIST;
close OUTFILE;



exit;