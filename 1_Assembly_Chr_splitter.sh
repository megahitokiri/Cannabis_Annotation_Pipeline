#!/usr/bin/env bash

#SBATCH --time=0-12:00:00
#SBATCH --nodes=2
#SBATCH --mem=190000M
#SBATCH -o logs/PK_Step1-%j.out
#SBATCH -e logs/PK_Step1-%j.err
#SBATCH --account=rpp-rieseber

########RUN EDTA on notchpeak.chpc or darjeeling for all assembly using singularity
########Retrieve DATA TO START PIPELINE
########e.g  singularity exec EDTA.sif EDTA.pl --genome PK_hap2.scaffold_8.fasta
#######################################
mkdir logs
mkdir EDTA_Files
mkdir Minimap_Aligned
mkdir Sorted_Chromosomes
mkdir Nanopore_FASTQ
mkdir Ref
mkdir Ref/Scaffold_split
unzip Maker_Files.zip
mkdir Post_Maker_Files
cp Assembly_Chr_splitter.R Ref

Reference="PK_hap2.09082021.fasta"
Assembly_hap="PK_hap2"

cd Ref
ml samtools

#Index FASTA file
samtools faidx $Reference

ml r/4.1.0

echo Assembly split into Chromosomes
R --vanilla < Assembly_Chr_splitter.R --args -f $Reference -a $Assembly_hap
mv *scaffold*.fasta Scaffold_split
rm Assembly_Chr_splitter.R 

ml unload r/4.1.0

ml unload samtools
echo "RUN EDTA IN ORDER TO CONTINUE THIS PIPELINE..."
