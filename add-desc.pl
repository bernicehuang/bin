use strict;
use warnings;


# ===========================================
# = declare variables from the command-line =
# ===========================================

my $infile = shift;
my $database = shift;
my $outfile = shift;



if(!defined($outfile)) {
	die "USAGE: perl $0 gene_annotation_file blast_results output_file\n";
}


# ==================================
# = open groupfile and set up hash =
# ==================================
# this is the file that has the orthomcl group and lists the genes that are in that group. The first loops, goes through and uses the gene id's as the hash key and then stores the orthogroup as the hash value. 

open ANNFILE, "$infile" or die "Error in opening $infile\n";


# declare variables
my ($genedesc, $geneid, $line);
my %groupHash;
my @cols;

# ignore header line
$line = <ANNFILE>;

while($line = <ANNFILE>) {
	
	chomp $line;
	
	@cols = split(/\t/, $line);
	$geneid = $cols[0];
	$genedesc = $cols[8];
	
	# print "$geneid\n";
	
	$groupHash{$geneid}{genedesc} = $genedesc;
}

close ANNFILE;



# =======================================
# = Read in the TTDB blast results file =
# =======================================
# this loop reads in the TTDB blast file. And using the gene id's it calls the hash that you created above and pulls in the orthomcl group. Then basically just adds the orthomcl group as another column, and prints out the output file. The output file will be read back in. 

# declare variables
my ($gene, $desc);
my @hit;



open BLASTFILE, "$database" or die "Error in opening $database\n";
open OUTFILE, ">$outfile" or die "Error in opening $outfile\n";



while ($line = <BLASTFILE>) {
	
	chomp $line;
	
	# parse blast file and separate out variables
	@cols = split(/\t/, $line);
	$gene = $cols[1];
	
	# extract the orthoMCL group based on the geneid.
	if(exists $groupHash{$gene}) {
		$desc = $groupHash{$gene}{genedesc};
		
		print OUTFILE "$gene\t$desc\t$line\n";
		
	} 
}

close BLASTFILE;
close OUTFILE;





exit;
