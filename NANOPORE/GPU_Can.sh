#!/usr/bin/env bash

#SBATCH --time=0-96:00:00
#SBATCH --ntasks=2
#SBATCH --mem=12000M
#SBATCH --gres=gpu:p100:1
#SBATCH --nodes=2
#SBATCH -o logs/GPU_Cannabis-%j.out
#SBATCH -e logs/GPU_Cannabis-%j.err
#SBATCH --account=def-rieseber

#salloc --time=1:0:0 --ntasks=2 --account=rpp-rieseber --gres=gpu:p100:1 --nodes=2 --mem=12000M

module use -a /home/jmlazaro/mymodules/modulefiles/Core

#Reference="/scratch/general/lustre/u1123911/Nanopore/Ref_Genome/c_elegans.PRJNA275000.WS277.genomic.fa"
ml GPU_guppy

#guppy_basecaller --trim_barcodes --compress_fastq -i FAP02733/fast5 -s FAP02733/basecall -c dna_r9.4.1_450bps_hac.cfg -x auto

ml unload guppy

###Combine all fastq into one
#echo cat all files into one fastq
#cat /scratch/jmlazaro/Cannabis/FAP02733/basecall/*.fastq.gz > /scratch/jmlazaro/Cannabis/FAP02733/Final_File/FAP02733_All_trimmed.fastq.gz

cat /scratch/Cannabis/FAP02733/Final_File/Trimmed/porechop /*.fastq.gz > /scratch/jmlazaro/Cannabis/FAP02733/Final_File/Porechop_FAP02733_All_trimmed.fastq.gz 
