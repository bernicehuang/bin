#!/bin/bash

#Version 1.0
#Version 1.1 now prints out nohits as well
#Version 1.2 location of secret blast database changed!

usage()
{
cat << EOF
usage: $0 options

This script blast against the secret (internal) database and generates stats.

Author : Vishal N Koparde, Ph. D.
Created : 120111
Modified : 120323
Version : 1.2

OPTIONS:
   -h     Show this message
   -f     Fasta file
   -n     number of ASGARD jobs (optional:default 10)
   -p	  percent read(query) alignment filter for BLAST output filtering (optional:default 50)
   -a	  alignment length filter for BLAST output (optional:default 50)
   -r 	  refiltering ,ie., do not run ASGARD again (use existing results) and refilter using new -p -a values. Use this only after running BLAST at least once!
EOF
}

if [ $# -eq 0 ]; then
	usage
	exit
fi

VBIN=/home/vnkoparde/bin
JBIN=/home/jmalves/bin
#SECRETBLASTDB=/data2/vahmp/databases-blast-etc/secret_blast_db
SECRETBLASTDB=/data/refdb/secret_blast_db
FASTAFILE=
PRA=50
AL=50
N=10
REFILTER=0
while getopts “hf:p:a:n:r?” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         f)
             FASTAFILE=$OPTARG
             ;;
         p)
             PRA=$OPTARG
             ;;
         n)
             N=$OPTARG
             ;;
         a)
             AL=$OPTARG
             ;;          
         r)
             REFILTER=1
             ;;          
         ?)
             usage
             exit
             ;;
     esac
done
if [ ! -f $FASTAFILE ]; then
	echo "A fasta file is required to perform BLAST!"
	usage
	exit
fi
NQUERY=`${VBIN}/get_num_reads.py -f fasta -i $FASTAFILE`
if [ $REFILTER -eq 0 ]; then
echo "BLASTing using ASGARD ..."
${JBIN}/asgard -w -j 1 -i $FASTAFILE -B -n $N -p blastn -d ${SECRETBLASTDB}/BCU_NoE_genome -d ${SECRETBLASTDB}/BO1_genome_1 -d ${SECRETBLASTDB}/CVS_1_Isotigs -d ${SECRETBLASTDB}/Ca037E_genome_2 -d ${SECRETBLASTDB}/CDE_NoE_genome -d ${SECRETBLASTDB}/CDE_2_reads -d ${SECRETBLASTDB}/CDS_NoE_genome -d ${SECRETBLASTDB}/CDS_5_reads -d ${SECRETBLASTDB}/Cfasc_2.4 -d ${SECRETBLASTDB}/CON_NoE_genome -d ${SECRETBLASTDB}/CON_1_reads -d ${SECRETBLASTDB}/Crysk_1 -d ${SECRETBLASTDB}/DMT_Isotigs -d ${SECRETBLASTDB}/DSP_g1 -d ${SECRETBLASTDB}/Es224_g2 -d ${SECRETBLASTDB}/Es224_isotigs -d ${SECRETBLASTDB}/Eclra_1 -d ${SECRETBLASTDB}/EGR_g2 -d ${SECRETBLASTDB}/EGR_cA -d ${SECRETBLASTDB}/Ehiem_1 -d ${SECRETBLASTDB}/Eprox_1 -d ${SECRETBLASTDB}/EstlU_2 -d ${SECRETBLASTDB}/EvirE_1 -d ${SECRETBLASTDB}/Eraam_EST_1 -d ${SECRETBLASTDB}/EVIR_g1 -d ${SECRETBLASTDB}/EVIRc_2 -d ${SECRETBLASTDB}/Etlbr_1 -d ${SECRETBLASTDB}/Glamb_pep -d ${SECRETBLASTDB}/H001E_genome -d ${SECRETBLASTDB}/H001E_3_reads -d ${SECRETBLASTDB}/Lm_genome_tt2.3 -d ${SECRETBLASTDB}/Lm_pep_tt2.3 -d ${SECRETBLASTDB}/Ltar_g_tt2.3 -d ${SECRETBLASTDB}/Lplay_1_Isotigs -d ${SECRETBLASTDB}/Ltrip_1 -d ${SECRETBLASTDB}/Lc169_g2 -d ${SECRETBLASTDB}/Lc169_2_reads -d ${SECRETBLASTDB}/MPY_1_Isotigs -d ${SECRETBLASTDB}/Ngrub_pep -d ${SECRETBLASTDB}/PCA_genome_10 -d ${SECRETBLASTDB}/BO1-c_1 -d ${SECRETBLASTDB}/PCT_cDNA2 -d ${SECRETBLASTDB}/Pinf_1 -d ${SECRETBLASTDB}/Porbc_1 -d ${SECRETBLASTDB}/Phyto_genome -d ${SECRETBLASTDB}/PLO_2 -d ${SECRETBLASTDB}/ST1_5_NoE -d ${SECRETBLASTDB}/ST1_3_reads -d ${SECRETBLASTDB}/SAC_1_Isotigs -d ${SECRETBLASTDB}/TEL_2 -d ${SECRETBLASTDB}/Tvcna_2 -d ${SECRETBLASTDB}/T1946_genome_5 -d ${SECRETBLASTDB}/T1946_5_reads -d ${SECRETBLASTDB}/TbB_g_tt2.3 -d ${SECRETBLASTDB}/TbG_g_tt2.3 -d ${SECRETBLASTDB}/Tcong_g_tt2.3 -d ${SECRETBLASTDB}/Tco_genome -d ${SECRETBLASTDB}/Tco_2_reads -d ${SECRETBLASTDB}/T1994_genome_4 -d ${SECRETBLASTDB}/T1994_4_reads -d ${SECRETBLASTDB}/TcCL_genome -d ${SECRETBLASTDB}/TcE_g_tt2.3 -d ${SECRETBLASTDB}/TcNE_g_tt2.3 -d ${SECRETBLASTDB}/TcU_g_tt2.3 -d ${SECRETBLASTDB}/TCE_g7.7 -d ${SECRETBLASTDB}/TCE_contigs -d ${SECRETBLASTDB}/TcG_genome -d ${SECRETBLASTDB}/TcG_contigs -d ${SECRETBLASTDB}/TJR4_g1 -d ${SECRETBLASTDB}/TcM62_1 -d ${SECRETBLASTDB}/TcSyl_1 -d ${SECRETBLASTDB}/TcTul_1 -d ${SECRETBLASTDB}/Td_2009-12-19 -d ${SECRETBLASTDB}/Td_contigs -d ${SECRETBLASTDB}/Td_EST -d ${SECRETBLASTDB}/Td_genes -d ${SECRETBLASTDB}/Tl034_genome_1 -d ${SECRETBLASTDB}/TrAM80_genome_2 -d ${SECRETBLASTDB}/TRA_1_reads -d ${SECRETBLASTDB}/Trang_am80_est_2010-08-13 -d ${SECRETBLASTDB}/Tr_Choachi_EST -d ${SECRETBLASTDB}/Tr_SC-58_EST -d ${SECRETBLASTDB}/Tviv_g_tt2.3
gzip -d blastres_${FASTAFILE}.gz
echo "Removing duplicates ..."
${JBIN}/rem_dup blastres_${FASTAFILE} > blastres_${FASTAFILE}.nodup
fi
echo "Filtering & Extracting Subject IDs ..."
${VBIN}/filter_blast_output.py -i blastres_${FASTAFILE}.nodup -pra $PRA -fasta $FASTAFILE -al $AL -subject_id_only -nohits blastres_${FASTAFILE}.nodup.nohits.fasta > blastres_${FASTAFILE}.nodup.subject_id_only
NHITS=`wc -l blastres_${FASTAFILE}.nodup.subject_id_only|awk '{print $1}'`
let "NNOHITS=NQUERY-NHITS"
cat blastres_${FASTAFILE}.nodup.subject_id_only |sort |sed -e 's/-/_/g'|awk -F "_" '{print $1}'|uniq -c > blastres_${FASTAFILE}.nodup.uniq 
echo " $NNOHITS DID_NOT_ALIGN " >> blastres_${FASTAFILE}.nodup.uniq 
cat blastres_${FASTAFILE}.nodup.uniq | sort -n -k1 -r > blastres_${FASTAFILE}.nodup.tmp
echo "Adding descriptions and sorting ..."
while read a b; do x=`grep -m 1 $b ${SECRETBLASTDB}/secret_blast_dbs | awk -F "|" '{print $2}'`; echo $a $b $x; done < blastres_${FASTAFILE}.nodup.tmp > blastres_${FASTAFILE}.nodup.hist_desc
rm -f blastres_${FASTAFILE}.nodup.subject_id_only
rm -f blastres_${FASTAFILE}.nodup.uniq 
rm -f blastres_${FASTAFILE}.nodup.tmp 
echo "Done!"
