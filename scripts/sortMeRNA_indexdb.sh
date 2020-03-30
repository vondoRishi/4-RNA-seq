#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J sortmerna
#SBATCH -o sortmerna_out_%j.txt
#SBATCH -e sortmerna_err_%j.txt
#SBATCH -p small
#SBATCH -n 1
#SBATCH -t 03:20:00
#SBATCH --mem-per-cpu=4000

source scripts/command_utility.sh

module load bioconda
source activate qiime2-2019.7

my_file=$sortMeRNA_ref

filename="${my_file%.*}"
echo $filename

index_file="$filename.idx"

echo $index_file

if [ ! -f $sortMeRNA_ref ]; then
	echo "rRNA fasta file is missing"
	exit 1 
fi
	

if [ ! -f "$index_file.stats" ]; then
	echo "rRNA fasta file will be indexed"
	indexdb_rna --ref $sortMeRNA_ref,$index_file
else
	echo "OK to run sortmerna"
fi

