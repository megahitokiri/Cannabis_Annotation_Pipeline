#!/usr/bin/env bash

#SBATCH --job-name="PK_EDTA"
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH -o logs/PK_EDTA-%N-%j.out
#SBATCH -e logs/PK_EDTA-%N-%j.err
#SBATCH --mail-user=megahitokiri@hotmail.com
#SBATCH --mail-type=BEGIN,END
#SBATCH --account=notchpeak
#SBATCH --partition=pezzolesi

ml singularity

for i in {1..10}
	do
	sbatch PK_EDTA_individual.sh ${i}	
	done   

