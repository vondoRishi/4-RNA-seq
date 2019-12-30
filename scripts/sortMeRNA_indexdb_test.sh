#!/bin/bash -l
#SBATCH -J sortmerna_idex
#SBATCH -o OUT/sortmerna_idx_out_test_%j.txt
#SBATCH -e ERROR/sortmerna_idx_err_test_%j.txt
#SBATCH --account=Project_2002302
#SBATCH -p test 
#SBATCH -n 1
#SBATCH --cpus-per-task=2 ## *Number of fastq files*
#SBATCH -t 00:15:00##12:50:00
#SBATCH --mem-per-cpu=4G
#SBATCH --mail-type=END




my_file="$HOME/rRNA_databases/rRNA_all.fasta"

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
	module load bioconda
  source activate qiime2-2019.7
	indexdb_rna --ref $sortMeRNA_ref,$index_file
else
	echo "OK to run sortmerna"
fi