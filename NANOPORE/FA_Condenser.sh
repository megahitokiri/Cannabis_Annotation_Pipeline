#!/usr/bin/env bash

#SBATCH --time=0-2:00:00
#SBATCH --nodes=1
#SBATCH --mem=190000M
#SBATCH -o logs/Expression-%j.out
#SBATCH -e logs/Expression-%j.err
#SBATCH --account=rpp-rieseber

Folder="FAQ04635/MOT19P01/basecall"
Flow_Cell="FAQ04635"
ListBAM="FAQ04635/MOT19P01/fastq_list.txt"

readarray BAM_file <$ListBAM

x=$((${#BAM_file[@]} -1))

for i in $(seq 0 $x)
	do
        FASTQ_Name=$(echo ${BAM_file[$i]} ) 
	FASTQ_Name_corrected=$(echo ${BAM_file[$i]} | sed 's/barcode/BP/g')
	
	echo working on: $Flow_Cell/${Flow_Cell}_${FASTQ_Name_corrected}_full.fastq 

	zcat $Folder/$FASTQ_Name/*.gz  > $Flow_Cell/${Flow_Cell}_${FASTQ_Name_corrected}_full.fastq
	gzip $Flow_Cell/${Flow_Cell}_${FASTQ_Name_corrected}_full.fastq 
	done
