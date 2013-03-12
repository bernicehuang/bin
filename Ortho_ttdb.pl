use strict;
use warnings;


# ===========================================
# = declare variables from the command-line =
# ===========================================

my $infile = shift;
my $groupfile = shift;
my $outfile = shift;
my $resultsoutfile = shift;


if(!defined($resultsoutfile)) {
	die "USAGE: perl $0 TTDB.blast.results OrthoMCL-groups-withgeneid output1.withorthomcl output2.ortho.ttdbcounts\n";
}


# ==================================
# = open groupfile and set up hash =
# ==================================

open GROUPFILE, "$groupfile" or die "Error in opening $groupfile\n";


# declare variables
my ($grpcount, $orthogrp, $org, $geneid, $line);
my %groupHash;
my @cols;

# print OUTFILE "RPS\tGene_ID\tOrg\tOrthoMCL_Group\tPFAM_COG_or_KOG\tperc_id\talign_len\tevalue\n";



while($line = <GROUPFILE>) {
	
	chomp $line;
	
	@cols = split(/\t/, $line);
	$orthogrp = $cols[0];
	$org = $cols[1];
	$geneid = $cols[2];
	
	# print "$geneid\n";
	
	$groupHash{$geneid}{orthogrp} = $orthogrp;
}

close GROUPFILE;



# =======================================
# = Read in the TTDB blast results file =
# =======================================

# declare variables
my ($evalue, $rpsdesc, $rpscount, $gene, $subid, $suborg, $subgene, $pi, $al, $sublen, $orthocount, $genecount);
my @hit;
my @subjectid;
my $ortho;


open INFILE, "$infile" or die "Error in opening $infile\n";
open OUTFILE, ">$outfile" or die "Error in opening $outfile\n";


# ignore the header line.
$line = <INFILE>;

while ($line = <INFILE>) {
	
	chomp $line;
	
	# parse blast file and separate out variables
	@cols = split(/\t/, $line);
	$gene = $cols[0];
	$pi = $cols[2];
	$al = $cols[3];
	$evalue = $cols[10];
	@subjectid = split(/\|/, $cols[1]);
	$subid = $subjectid[1];
	@hit = split(/\|/, $cols[15]);
	
	if($hit[1] =~ /organism=(.*)\s/) {
		$suborg = $1;
	}
	
	if ($hit[2] =~ /product=(.*)/) {
		$subgene = $1;
	}
	
	if ($hit[4] =~ /length=(.*)/) {
		$sublen = $1;
	}

	# extract the orthoMCL group based on the geneid.
	if(exists $groupHash{$gene}) {
		$ortho = $groupHash{$gene}{orthogrp};
		
		print OUTFILE "$ortho\t$gene\t$subid\t$suborg\t$subgene\t$sublen\t$pi\t$al\t$evalue\n";
	} 
}

close INFILE;
close OUTFILE;


# ============================================
# = Open the outfile that you just created.  =
# ============================================

my %ttdbHash;

# open the outfile for reading. 
open OUTFILE, "$outfile" or die "Error in opening $outfile\n";
open RESULTSOUTFILE, ">$resultsoutfile" or die "Error in opening $resultsoutfile\n";

while ($line = <OUTFILE>) {
	
	chomp $line;
	
	@cols = split(/\t/, $line);
	$ortho = $cols[0];
	$gene = $cols[1];
	$subid = $cols[2];
	$suborg = $cols[3];
	$subgene= $cols[4];
	$sublen = $cols[5];
	$pi = $cols[6];
	$al = $cols[7];
	$evalue = $cols[8];
	# print "ortho in second file is $ortho\n";
	
	if(exists $ttdbHash{$ortho} && exists $ttdbHash{$ortho}{$suborg} && exists $ttdbHash{$ortho}{$suborg}{$subgene}) {
		$ttdbHash{$ortho}{$suborg}{$subgene}++;
	} else {
		$ttdbHash{$ortho}{$suborg}{$subgene} = 1;
	}
}



foreach $ortho(keys %ttdbHash) {
	# print "geneid = $ortho\n";
	# $orthocount = $ttdbHash{$ortho}{count};
	# print "$ortho\t";
	
	foreach $suborg(keys %{$ttdbHash{$ortho}}) {
		# $genecount = $ttdbHash{$ortho}{$suborg};
		# print "$suborg\n";
		
		foreach $subgene(keys %{$ttdbHash{$ortho}{$suborg}}) {
			$genecount = $ttdbHash{$ortho}{$suborg}{$subgene};
			print RESULTSOUTFILE "$ortho\t$suborg\t$subgene\t$genecount\n";
		}
	}
}


close OUTFILE;
close RESULTSOUTFILE;





exit;
