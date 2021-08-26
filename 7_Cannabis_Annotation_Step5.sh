#!/usr/bin/env bash

#SBATCH --time=0-1:00:00
#SBATCH --nodes=1
#SBATCH --mem=190000M
#SBATCH -o logs/PK_Step4-%j.out
#SBATCH -e logs/PK_Step4-%j.err
#SBATCH --account=rpp-rieseber


Assembly="PK_hap2"
mkdir FINAL_ANNOTATION_${Assembly}

cd Post_Maker_Files 

cat MAKER_ORF_Filtered_${Assembly}.scaffold_1.gff3 > FINAL_${Assembly}.gff3

for i in {2..11}
  do
  echo "Merging GFF3 Files Chr $i on $Assembly Assembly"
  tail -n +4 MAKER_ORF_Filtered_${Assembly}.scaffold_${i}.gff3 >> FINAL_${Assembly}.gff3
  done

cd ..
cp  Post_Maker_Files/FINAL_${Assembly}.gff3 FINAL_ANNOTATION_${Assembly}/FINAL_${Assembly}.gff3
