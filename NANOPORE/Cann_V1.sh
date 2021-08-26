#!/usr/bin/env bash

#SBATCH --time=0-96:00:00
#SBATCH --nodes=1
#SBATCH --mem=190000M
#SBATCH -o logs/Cann_N2-%j.out
#SBATCH -e logs/Cann_N2-%j.err
#SBATCH --account=rpp-rieseber

module use -a /home/jmlazaro/mymodules/modulefiles/Core

#Reference="/scratch/general/lustre/u1123911/Nanopore/Ref_Genome/c_elegans.PRJNA275000.WS277.genomic.fa"
ml guppy

guppy_basecaller --trim_barcodes  --compress_fastq -i FAP02733/fast5 -s FAP02733/basecall \
	--cpu_threads_per_caller 14 --num_callers 1 -c dna_r9.4.1_450bps_hac.cfg

ml unload guppy

###Combine all fastq into one
#echo cat all files into one fastq
cat /scratch/jmlazaro/Cannabis/FAP02733/basecall/*.fastq.gz > /scratch/jmlazaro/Cannabis/FAP02733/Final_File/FAP02733_All.fastq.gz

