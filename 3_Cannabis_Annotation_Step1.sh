#!/usr/bin/env bash

#SBATCH --time=0-12:00:00
#SBATCH --nodes=2
#SBATCH --mem=190000M
#SBATCH -o logs/PK_Step1-%j.out
#SBATCH -e logs/PK_Step1-%j.err
#SBATCH --account=rpp-rieseber

#####BEFORE RUNNING CHECK TOTAL NUMBER OF CONTIGS in the fasta file 

Reference_Original="PK_hap2.09082021"
Reference="PK_hap2"
Fastq_File="Nanopore_FASTQ/FAP02733_Porechop_No_Trim_Final.fastq.gz"

ml minimap2
echo Minimap will proceed with the alignment.
echo Minimap Indexing
minimap2 -ax map-ont -t 12 -2 Ref/${Reference_Original}.fasta $Fastq_File > Minimap_Aligned/${Reference}_minimap2.sam 

ml unload minimap2

ml samtools
echo SAM to BAM convertion
samtools view -S -b Minimap_Aligned/${Reference}_minimap2.sam  > Minimap_Aligned/${Reference}_minimap2.bam

echo  BAM sorting
samtools sort Minimap_Aligned/${Reference}_minimap2.bam -o Minimap_Aligned/${Reference}_minimap2.sorted.bam

echo BAM indexing.....
samtools index  Minimap_Aligned/${Reference}_minimap2.sorted.bam
​
echo Applying MAPQ20 quality filter
samtools view -bq 20 Minimap_Aligned/${Reference}_minimap2.sorted.bam > Minimap_Aligned/${Reference}_minimap2.sorted.MAPQ20.bam

echo Removing duplicates from Bam File
samtools rmdup -s Minimap_Aligned/${Reference}_minimap2.sorted.MAPQ20.bam  Minimap_Aligned/${Reference}_minimap2.sorted.MAPQ20.dedup.bam

echo BAM indexing SORTED QUALITY FILTERED AND DEDUP.....
samtools index  Minimap_Aligned/${Reference}_minimap2.sorted.MAPQ20.dedup.bam

samtools idxstats Minimap_Aligned/${Reference}_minimap2.sorted.MAPQ20.dedup.bam
Contig_Number=$( samtools idxstats Minimap_Aligned/${Reference}_minimap2.sorted.MAPQ20.dedup.bam | wc -l )
Contig_Number=$((Contig_Number - 1))
echo NUMBER OF CONTIGS: $Contig_Number 

ml seqtk
for i in {1..11}
	do
	echo "Extracting chromosome $i"
	samtools view -b Minimap_Aligned/${Reference}_minimap2.sorted.MAPQ20.dedup.bam scaffold_$i > Minimap_Aligned/${Reference}.chr${i}.bam
	samtools index Minimap_Aligned/${Reference}.chr${i}.bam

	echo Transforming Bam to Fasta
	samtools bam2fq Minimap_Aligned/${Reference}.chr${i}.bam | seqtk seq -A - > Sorted_Chromosomes/${Reference}.chr${i}.fasta 
	done

for ((i=12; i<=$Contig_Number; i++))
	do
	samtools view -b Minimap_Aligned/${Reference}_minimap2.sorted.MAPQ20.dedup.bam scaffold_$i > Minimap_Aligned/${Reference}.chr${i}.bam
	samtools index Minimap_Aligned/${Reference}.chr${i}.bam
	echo Adding to Chr11 Fasta
	samtools bam2fq Minimap_Aligned/${Reference}.chr${i}.bam | seqtk seq -A - >> Sorted_Chromosomes/${Reference}.chr11.fasta
	done

ml unload seqtk
ml unload samtools
