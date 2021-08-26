#!/usr/bin/env bash

#SBATCH --time=0-48:00:00
#SBATCH --ntasks=2
#SBATCH --mem=12000M
#SBATCH --gres=gpu:p100:1
#SBATCH --nodes=2
#SBATCH -o logs/GPU_Cannabis-%j.out
#SBATCH -e logs/GPU_Cannabis-%j.err
#SBATCH --account=def-rieseber

#salloc --time=1:0:0 --ntasks=2 --account=rpp-rieseber --gres=gpu:p100:1 --nodes=2 --mem=12000M

module use -a /home/jmlazaro/mymodules/modulefiles/Core

Folder_Origen="Cannabis_RNA_SS_NOT20109/SS_ML_Stem_SApx_Roots_FemBuds_MaleBuds/20210514_2324_MN35744_FAQ04957_61e4f528/fast5"
Folder_Destino="FAQ04957/SkunkNOT20109/basecall"


mkdir $Folder_Destino

ml GPU_guppy

guppy_basecaller --trim_barcodes --barcode_kits SQK-PCB109 --compress_fastq -i $Folder_Origen \
	-s $Folder_Destino -c dna_r9.4.1_450bps_hac.cfg -x auto 

ml unload guppy

###Combine all fastq into one
#echo cat all files into one fastq
#cat /scratch/jmlazaro/Cannabis/FAP02733/basecall/*.fastq.gz > /scratch/jmlazaro/Cannabis/FAP02733/Final_File/FAP02733_All_trimmed.fastq.gz

#cat /scratch/Cannabis/FAP02733/Final_File/Trimmed/porechop /*.fastq.gz > /scratch/jmlazaro/Cannabis/FAP02733/Final_File/Porechop_FAP02733_All_trimmed.fastq.gz 
