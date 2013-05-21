use strict;
use warnings;


# ===========================================
# = declare variables from the command-line =
# ===========================================

my $fasta = shift;
my $seqid = shift;
my $outfile = shift;


if(!defined($outfile)) {
	die "USAGE: perl $0 fasta-file seq-id outfile\n";
}



# =================================================
# = Open and store fasta file sequences in a Hash =
# =================================================

open FASTA, "$fasta" or die "Error in opening $fasta\n";

# declare variables
my $seq = "";
my ($seqline, $fastaacc, $contig, $start, $end, $len);
my %geneHash;


while ($seqline = <FASTA>) {
	
	chomp $seqline;
	
	if ($seqline =~ /^>(.*)\s/) {
		
		$contig = $1;
		# print "here is the fasta header line:\n$fastaacc, $len\n";
		$seq = "";

	} else {
		$seq .= $seqline;
		$geneHash{$contig}{seq} = $seq;
			# print "here is the sequence:\n$seq";
	}
}

close FASTA;

# 
# foreach $fastaacc(keys %fastaHash) {
# 	print "fasta acc = $fastaacc\n";
# }




# ===================================================
# = open and loop through file to extract sequences =
# ===================================================

# declare variables
my %seqHash;
my ($line, $orthogrp, $org, $geneid);
my @cols;
my $contigid;


open SEQID, "$seqid" or die "Error in opening $seqid\n";
open OUTFILE, ">$outfile" or die "Error in opening $outfile\n";

# ignore the header line.
# $line = <SEQID>;

while ($line = <SEQID>) {
	
	chomp $line;
	
	if(exists $geneHash{$line}) {
		$contigid = $geneHash{$line}{seq};
	}
	

	
	# print "Accession, start, end, number of nucleotides = $orthogrp, $org, $geneid\n";
	

	
	# $extract = substr($fastaseq, $start - 1, $numofnt);
	
	print OUTFILE ">$line\n$contigid\n";
	
}


close SEQID;
close OUTFILE;






exit;
