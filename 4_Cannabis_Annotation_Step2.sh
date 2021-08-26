#!/usr/bin/env bash

#SBATCH --time=0-1:00:00
#SBATCH --nodes=1
#SBATCH --mem=190000M
#SBATCH -o logs/PK_Step2-%j.out
#SBATCH -e logs/PK_Step2-%j.err
#SBATCH --account=rpp-rieseber
BASEDIR=$PWD 

cd Maker_Files
Assembly="PK_hap2"
Reference_genome="Ref/Scaffold_split/${Assembly}"
EST_File="Sorted_Chromosomes/${Assembly}"
Protein_File="Maker_Files/csa.trans.Protein.10072011.fasta"
Repeats_File="Maker_Files/PK_Repeat_contigs_RE_filtered_min500bp.fa"

###Repeats curated from EDTA file and post processed in ORF analysis
###BREAK the reference Genome into chr subgenomes using Biostrings in R standalone code

for i in {1..11}
	do
	echo "Creating Maker Files Chr $i on $Assembly Assembly"
	mkdir ${Assembly}_Chr$i
	cd ${Assembly}_Chr$i
	maker -CTL
	cd ..
	cp maker_opts.template ${Assembly}_Chr$i/maker_opts.ctl
	echo "########################" >> ${Assembly}_Chr$i/maker_opts.ctl
	echo "#-----Custom Parameters (these are always required)" >> ${Assembly}_Chr$i/maker_opts.ctl
	echo "genome=$BASEDIR/${Reference_genome}.scaffold_${i}.fasta" >> ${Assembly}_Chr$i/maker_opts.ctl
	echo "est=$BASEDIR/${EST_File}.chr${i}.fasta" >> ${Assembly}_Chr$i/maker_opts.ctl
	echo "protein=$BASEDIR/${Protein_File}" >> ${Assembly}_Chr$i/maker_opts.ctl
	echo "repeat_protein=$BASEDIR/${Repeats_File}" >> ${Assembly}_Chr$i/maker_opts.ctl
	echo "augustus_species=arabidopsis" >> ${Assembly}_Chr$i/maker_opts.ctl

	cp Run_Maker.bash ${Assembly}_Chr$i
	cd  ${Assembly}_Chr$i 
	sbatch Run_Maker.bash 
	cd ..
	done
