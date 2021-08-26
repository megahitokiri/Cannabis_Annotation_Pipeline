#!/usr/bin/env bash

#SBATCH --time=0-96:00:00
#SBATCH --nodes=1
#SBATCH --mem=190000M
#SBATCH -o logs/Cann_Step2-%j.out
#SBATCH -e logs/Cann_Step2-%j.err
#SBATCH --account=rpp-rieseber

Reference="/home/jmlazaro/scratch/Cannabis/Ref/GCA_000230575.5_ASM23057v5_genomic.fna"
Fastq_File="/home/jmlazaro/scratch/Cannabis/SRR/Processed_SRR7285294.fastq"

ml minimap2
echo Minimap will proceed with the alignment.
echo Minimap Indexing
minimap2 -ax map-ont -t 8 $Reference $Fastq_File > /home/jmlazaro/scratch/Cannabis/SRR/minimap2_SRR7285294.sam 

ml unload minimap2

ml samtools
echo SAM to BAM convertion
samtools view -S -b /home/jmlazaro/scratch/Cannabis/SRR//home/jmlazaro/scratch/Cannabis/SRR/minimap2_SRR7285294.sam  > /home/jmlazaro/scratch/Cannabis/SRR//home/jmlazaro/scratch/Cannabis/SRR/minimap2_SRR7285294.bam

echo  BAM sorting
samtools sort /home/jmlazaro/scratch/Cannabis/SRR/minimap2_SRR7285294.bam -o /home/jmlazaro/scratch/Cannabis/SRR/minimap2_SRR7285294.sorted.bam

echo BAM indexing.....
samtools index  /home/jmlazaro/scratch/Cannabis/SRR/minimap2_SRR7285294.sorted.bam
​
echo Extracting chromosome 1 CM010790.2
samtools view -b /home/jmlazaro/scratch/Cannabis/SRR/minimap2_SRR7285294.sorted.bam CM010790.2 >  /home/jmlazaro/scratch/Cannabis/SRR/SRR_chr1_CM010790_2.bam

ml unload samtools
