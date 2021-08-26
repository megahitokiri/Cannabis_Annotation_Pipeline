#!/usr/bin/env bash

#SBATCH --time=0-2:00:00
#SBATCH --nodes=1
#SBATCH --mem=190000M
#SBATCH -o logs/Condenser_4646-%j.out
#SBATCH -e logs/Condenser_4646-%j.err
#SBATCH --account=rpp-rieseber

Folder="FAQ02599/MOC20P01/basecall"
Flow_Cell="FAQ02599"
ListBAM="FAQ02599/MOC20P01/fastq_list.txt"

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
