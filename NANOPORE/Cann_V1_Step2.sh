#!/usr/bin/env bash

#SBATCH --time=0-3:00:00
#SBATCH --nodes=1
#SBATCH --mem=190000M
#SBATCH -o logs/Cann_Step2-%j.out
#SBATCH -e logs/Cann_Step2-%j.err
#SBATCH --account=rpp-rieseber

Reference="Ref/PK_hap2.09082021.fasta"
Fastq_File="home/jmlazaro/Cannabis/Porechop_No_Trim_Final.fastq.gz"

ml minimap2
echo Minimap will proceed with the alignment.
echo Minimap Indexing
minimap2 -ax map-ont -t 8 $Reference $Fastq_File > /home/jmlazaro/scratch/Cannabis/Minimap_Aligned/PK_hap2.09082021_minimap2.sam 

ml unload minimap2

ml samtools
echo SAM to BAM convertion
samtools view -S -b /home/jmlazaro/scratch/Cannabis/Minimap_Aligned/PK_hap2.09082021_minimap2.sam  > /home/jmlazaro/scratch/Cannabis/Minimap_Aligned/PK_hap2.09082021_minimap2.bam

echo  BAM sorting
samtools sort /home/jmlazaro/scratch/Cannabis/Minimap_Aligned/PK_hap2.09082021_minimap2.bam -o /home/jmlazaro/scratch/Cannabis/Minimap_Aligned/PK_hap2.09082021_minimap2.sorted.bam

echo BAM indexing.....
samtools index  /home/jmlazaro/scratch/Cannabis/Minimap_Aligned/PK_hap2.09082021_minimap2.sorted.bam
​
echo Extracting chromosome 1 CM010790.2
samtools view -b /home/jmlazaro/scratch/Cannabis/Minimap_Aligned/PK_hap2.09082021_minimap2.sorted.bam scaffold_1 >  /home/jmlazaro/scratch/Cannabis/Minimap_Aligned/chr1_PK_hap2.09082021.bam

ml seqtk

echo Transforming Bam to Fasta
samtools bam2fq /home/jmlazaro/scratch/Cannabis/Minimap_Aligned/chr1_PK_hap2.09082021.bam | seqtk seq -A - > Sorted_Chromosomes/chr1_PK_hap2.09082021.fasta 

ml unload seqtk
ml unload samtools
