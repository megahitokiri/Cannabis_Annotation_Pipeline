#!/usr/bin/env bash

#SBATCH --time=0-48:00:00
#SBATCH --ntasks=2
#SBATCH --mem=12000M
#SBATCH --gres=gpu:p100:1
#SBATCH --nodes=2
#SBATCH -o logs/GPU_Cannabis_FAQ20806.sh-%j.out
#SBATCH -e logs/GPU_Cannabis_FAQ20806-%j.err
#SBATCH --account=def-rieseber

#salloc --time=1:0:0 --ntasks=2 --account=rpp-rieseber --gres=gpu:p100:1 --nodes=2 --mem=12000M

module use -a /home/jmlazaro/mymodules/modulefiles/Core

Folder_Origen="Cannabis_RNA_MKULTRA_POT19P08/MKULTRA_FemFlower_JA_SA_SugarLeaves/20210604_2151_MN25889_FAQ20806_0491036f/fast5/"
Folder_Destino="FAQ20806/POT19P08/basecall"


mkdir $Folder_Destino

ml GPU_guppy

guppy_basecaller --trim_barcodes --barcode_kits SQK-PCB109 --compress_fastq -i $Folder_Origen \
	-s $Folder_Destino -c dna_r9.4.1_450bps_hac.cfg -x auto 

ml unload guppy

###Combine all fastq into one
#echo cat all files into one fastq
#cat /scratch/jmlazaro/Cannabis/FAP02733/basecall/*.fastq.gz > /scratch/jmlazaro/Cannabis/FAP02733/Final_File/FAP02733_All_trimmed.fastq.gz

#cat /scratch/Cannabis/FAP02733/Final_File/Trimmed/porechop /*.fastq.gz > /scratch/jmlazaro/Cannabis/FAP02733/Final_File/Porechop_FAP02733_All_trimmed.fastq.gz 
