#!/usr/bin/env bash
input_file=$1
output_file=$2


# Directory to store individual sequences
fasta_dir=$(basename ${input_file%.*})_sequences

if [ ! -d $fasta_dir ]; then
  mkdir "$fasta_dir"
fi

# Split input file into individual fasta files
awk '/^>/ {close(OUT); ++c; OUT="'$fasta_dir'/" substr($0,2) ".fasta";
  gsub(/ /, "", OUT)}
{ print > OUT; }' $input_file

# Loop through individual fasta files
fasta_files=$fasta_dir/*

for f in $fasta_files; do
  etandem -sequence $f -minrepeat 6 -maxrepeat 50 -outfile $f.etandem
  rm $f
done;

# run perl script to combine all the etandem output files.
perl ~/bin/1-filter_etandem.pl $fasta_dir $output_file


