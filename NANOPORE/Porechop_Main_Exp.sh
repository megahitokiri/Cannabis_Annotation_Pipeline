#!/usr/bin/env bash

#SBATCH --time=0-1:00:00
#SBATCH --nodes=1
#SBATCH --mem=190000M
#SBATCH -o logs/Expression-%j.out
#SBATCH -e logs/Expression-%j.err
#SBATCH --account=rpp-rieseber

ListBAM="/home/jmlazaro/scratch/Cannabis/FAP02733/basecall_with_adapters/fastq_list.txt"

readarray BAM_file <$ListBAM

x=$((${#BAM_file[@]} -1))

for i in $(seq 0 $x)
	do
	BAM_Name=$(echo ${BAM_file[$i]} | sed 's/_sort\.bam/_sort/g')

	sbatch Porechop_individual.sh $BAM_Name

	done
