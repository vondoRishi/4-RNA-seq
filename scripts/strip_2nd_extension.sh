#!/bin/bash -l
#Modified by Qiang Lan from Rishi's 4-rna-seq scripts on 20.12.2019
#SBATCH -J remove_fastq_extra
#SBATCH -o extra_remove_out_%j.txt
#SBATCH -e extra_remove_err_%j.txt
#SBATCH --account=Project_2002302
#SBATCH -p large 
#SBATCH -n 1
#SBATCH --cpus-per-task=1 ## *Number of fastq files*
#SBATCH -t 12:50:00
#SBATCH --mem-per-cpu=1G
#SBATCH --mail-type=END

for my_file in $1/*
do
if [  -f "$my_file" ]
   then
        filename="${my_file##*/}"
        extension="${filename##*.}"
        filename="${filename%.*}"
        filename="${filename%.*}"
        
        mv $my_file $1/$filename.$extension
fi
done