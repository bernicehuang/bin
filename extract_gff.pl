use strict;
use warnings;

my $infile = shift;
my $genelist = shift;
my $outfile = shift;


#purpose of this script is to take a list of genes and use it to extract those genes out of a genes.gff file. 


if (!defined($outfile)) {
	die "USAGE: perl $0 1-infile-gene-gff.file 2-list-of-geneids 3-outfile\n";
}
	
my ($line, $geneid, $one, $two, $three, $four, $five, $six, $seven, $eight);
my @cols;
my %geneHash;


open INFILE, "$infile" or die "error in opening $infile\n";
open OUTFILE, ">$outfile" or die "error in opening $outfile\n";


# skip the first line
$line = <INFILE>;

while($line = <INFILE>) {
	
	chomp $line;
	@cols = split(/\t/, $line);
  
	$geneid = $cols[8];
	# print OUTFILE "$geneid\n";
	
	$geneHash{$geneid}{one} = $cols[0];
	$geneHash{$geneid}{two} = $cols[1];
	$geneHash{$geneid}{three} = $cols[2];
	$geneHash{$geneid}{four} = $cols[3];
	$geneHash{$geneid}{five} = $cols[4];
	$geneHash{$geneid}{six} = $cols[5];
	$geneHash{$geneid}{seven} = $cols[6];
	$geneHash{$geneid}{eight} = $cols[7];
	
}


close INFILE;


open GENELIST, "$genelist" or die "error in opening $genelist\n";


while($line = <GENELIST>) {
	chomp $line;
	if (exists $geneHash{$line}) {
		$one = $geneHash{$line}{one};
		$two = $geneHash{$line}{two};
		$three = $geneHash{$line}{three};
		$four = $geneHash{$line}{four};
		$five = $geneHash{$line}{five};
		$six = $geneHash{$line}{six};
		$seven = $geneHash{$line}{seven};
		$eight = $geneHash{$line}{eight};
		print OUTFILE "$one\t$two\t$three\t$four\t$five\t$six\t$seven\t$eight\t$line\n";
	}

}


close GENELIST;
close OUTFILE;

exit;