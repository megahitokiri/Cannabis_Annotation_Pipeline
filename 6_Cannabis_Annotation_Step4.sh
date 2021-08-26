#!/usr/bin/env bash

#SBATCH --time=0-1:00:00
#SBATCH --nodes=1
#SBATCH --mem=190000M
#SBATCH -o logs/PK_Step4-%j.out
#SBATCH -e logs/PK_Step4-%j.err
#SBATCH --account=rpp-rieseber


Assembly="PK_hap2"
cp -v Maker_Files/${Assembly}*/*.gff3 Post_Maker_Files
cp -v Post_Maker_ORF_Analysis_Terminal.R Post_Maker_Files
cp -v Ref/Scaffold_split/*.* Post_Maker_Files
cp -v EDTA_Files/*masked* Post_Maker_Files
cp -v Maker_Files/Post_Maker_Processing.sh Post_Maker_Files 
sed -i 's/time=0-1:00:00/time=0-12:00:00/g' Post_Maker_Files/Post_Maker_Processing.sh

cd Post_Maker_Files 
for i in {1..11}
  do
  echo "Creating Post_Maker Files Chr $i on $Assembly Assembly"
  cp -v Post_Maker_Processing.sh Post_Maker_Processing_Chr${i}.sh
  sed -i "s/log_Post_Maker-/log_Post_Maker-Chr${i}-/g" Post_Maker_Processing_Chr${i}.sh
  echo "R --vanilla < Post_Maker_ORF_Analysis_Terminal.R --args -g MAKER_Filtered_${Assembly}.scaffold_${i}.all.AED_0.8.gff3 -a ${Assembly}.scaffold_${i}.fasta -m ${Assembly}.scaffold_${i}.masked.fasta -o ${Assembly}.scaffold_${i}" >> Post_Maker_Processing_Chr${i}.sh
  sbatch Post_Maker_Processing_Chr${i}.sh
  done
