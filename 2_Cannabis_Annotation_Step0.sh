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

Reference="PK_hap2.scaffold"

ml bedtools

for i in {1..11}
	do
	echo "Creating Masked Reference Genome for $Refernce on Chr: $i"
	bedtools maskfasta -fi Ref/Scaffold_split/${Reference}_${i}.fasta -bed EDTA_Files/${Reference}_${i}.fasta.mod.EDTA.intact.gff3 -fo EDTA_Files/${Reference}_${i}.masked.fasta
	done

ml unload bedtools
