#!/usr/bin/env bash

#SBATCH --job-name="PK_EDTA"
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH -o logs/PK_EDTA-%N-%j.out
#SBATCH -e logs/PK_EDTA-%N-%j.err
#SBATCH --mail-user=megahitokiri@hotmail.com
#SBATCH --mail-type=BEGIN,END
#SBATCH --account=pezzolesi
#SBATCH --partition=notchpeak

Chr=$1
ml singularity

echo starting EDTA process on singularity

singularity exec EDTA.sif EDTA.pl --genome PK_hap2.scaffold_${Chr}.fasta
