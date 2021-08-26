#!/usr/bin/env bash

#SBATCH --time=0-0:10:00
#SBATCH --nodes=1
#SBATCH --mem=110000M
#SBATCH -o logs/Porechop-%j.out
#SBATCH -e logs/Porechop-%j.err
#SBATCH --account=rpp-rieseber

File_Name=$1

echo Starting Porechop on: $File_Name

porechop -i /home/jmlazaro/scratch/Cannabis/FAP02733/basecall_with_adapters/$File_Name -o /home/jmlazaro/scratch/Cannabis/FAP02733/Final_File_with_adapters/porechop/porechop_$File_Name

echo Finishing with exit code $?
