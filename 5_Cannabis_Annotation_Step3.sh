#!/usr/bin/env bash

#SBATCH --time=0-1:00:00
#SBATCH --nodes=1
#SBATCH --mem=190000M
#SBATCH -o logs/PK_Step3-%j.out
#SBATCH -e logs/PK_Step3-%j.err
#SBATCH --account=rpp-rieseber

cd Maker_Files
Assembly="PK_hap2"
Reference_genome="PK_hap2"
AED_filter="0.8"

###Repeats get using perl EDTA command
###BREAK the reference Genome into chr subgenomes using Biostrings in R standalone code

for i in {1..11}
	do
	echo "Creating Post_Maker Files Chr $i on $Assembly Assembly"

        cp Post_Maker_Processing.sh ${Assembly}_Chr$i/Post_Maker_Processing.sh
	cp quality_filter.pl ${Assembly}_Chr$i/${Reference_genome}.scaffold_${i}.maker.output
	echo "#######POST_PROCESSING#################" >> ${Assembly}_Chr$i/Post_Maker_Processing.sh
        echo "#######################################" >> ${Assembly}_Chr$i/Post_Maker_Processing.sh
        echo "cd ${Reference_genome}.scaffold_${i}.maker.output" >> ${Assembly}_Chr$i/Post_Maker_Processing.sh
        echo "fasta_merge -d ${Reference_genome}.scaffold_${i}_master_datastore_index.log" >> ${Assembly}_Chr$i/Post_Maker_Processing.sh
        echo "gff3_merge -d ${Reference_genome}.scaffold_${i}_master_datastore_index.log" >> ${Assembly}_Chr$i/Post_Maker_Processing.sh
#        echo "\$BLASTP -query ${Reference_genome}.scaffold_${i}.all.maker.proteins.fasta -db /home/jmlazaro/scratch/blast_DB/uniprot_sprot  -evalue 1e-6 -max_hsps 1 -max_target_seqs 1 -outfmt 6 -out ${Reference_genome}.scaffold_${i}.all.maker.proteins.fasta.blastp" >> ${Assembly}_Chr$i/Post_Maker_Processing.sh
	echo "maker_map_ids --prefix ${Reference_genome}_Chr${i}_ --justify 8 ${Reference_genome}.scaffold_${i}.all.gff > map" >> ${Assembly}_Chr$i/Post_Maker_Processing.sh 
	echo "map_gff_ids map ${Reference_genome}.scaffold_${i}.all.gff" >> ${Assembly}_Chr$i/Post_Maker_Processing.sh 
	echo "map_fasta_ids map ${Reference_genome}.scaffold_${i}.all.maker.proteins.fasta" >> ${Assembly}_Chr$i/Post_Maker_Processing.sh 
	echo "map_fasta_ids map  ${Reference_genome}.scaffold_${i}.all.maker.transcripts.fasta" >> ${Assembly}_Chr$i/Post_Maker_Processing.sh
	echo "echo #####AED filter#####">> ${Assembly}_Chr$i/Post_Maker_Processing.sh
	echo "perl quality_filter.pl -a ${AED_filter} ${Reference_genome}.scaffold_${i}.all.gff > ${Reference_genome}.scaffold_${i}.all.AED_${AED_filter}.gff " >> ${Assembly}_Chr$i/Post_Maker_Processing.sh 
	echo "echo #####Legacy Filter#####" >> ${Assembly}_Chr$i/Post_Maker_Processing.sh
	echo "cd .." >> ${Assembly}_Chr$i/Post_Maker_Processing.sh
	echo "sed -n 1p ${Reference_genome}.scaffold_${i}.maker.output/${Reference_genome}.scaffold_${i}.all.AED_${AED_filter}.gff > MAKER_Filtered_${Reference_genome}.scaffold_${i}.all.AED_${AED_filter}.gff3" >> ${Assembly}_Chr$i/Post_Maker_Processing.sh
	echo "awk '\$2 == \"maker\"' ${Reference_genome}.scaffold_${i}.maker.output/${Reference_genome}.scaffold_${i}.all.AED_${AED_filter}.gff >> MAKER_Filtered_${Reference_genome}.scaffold_${i}.all.AED_${AED_filter}.gff3" >> ${Assembly}_Chr$i/Post_Maker_Processing.sh

	echo "cd ${Reference_genome}.scaffold_${i}.maker.output" >> ${Assembly}_Chr$i/Post_Maker_Processing.sh

	cd  ${Assembly}_Chr$i
	sbatch Post_Maker_Processing.sh 
	cd ..
	done
