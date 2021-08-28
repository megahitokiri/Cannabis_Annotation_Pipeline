#!/usr/bin/env bash

#SBATCH --time=0-12:00:00
#SBATCH --nodes=2
#SBATCH --mem=190000M
#SBATCH -o logs/PK_EDTA_Step1-%j.out
#SBATCH -e logs/PK_EDTA_Step1-%j.err
#SBATCH --account=rpp-rieseber

########RUN EDTA on conda environment
Genome_Fasta=$1

cd EDTA_Files 

eval "$(conda shell.bash hook)"

conda activate EDTA

	echo starting EDTA process on Chromosome: $Chr
	EDTA.pl --genome $Genome_Fasta
conda deactivate
