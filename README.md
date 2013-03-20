general purpose scripts
=======================
These are the scripts in my bin folder on godel.

**ann_diff**

* Nihar wrote this script for me to annotate the cuffdiff output with human gene descriptions.

```
ann_diff 1-cufflinks-output 2-output
```

**run_etandem.sh**
*This script calls the ```1-filter_etandem.pl``` script which calls the ```filter_etandem.pl``` script.
*Purpose is to look for tandem repeats. 
  * The emboss etandem program requires individual fasta files as its input, so this script creates a folder and loops through an assembly file and creates an individual fasta file labeled with the contig id for each contig. 
  * Then, loops through the folder and runs etandem on each fasta file. This will generate an etandem output file for each contig.
  * The ```1-filter_etandem.pl and filter_etandem.pl``` will then read in each etandem output file, determine if any repeats were found, and if there were repeats found it will add the contig_id, from the file name, as a new column and concatenate the output to one file. 

```
run_etandem.sh 1-genome-assembly.file 2-output.etandem
```

