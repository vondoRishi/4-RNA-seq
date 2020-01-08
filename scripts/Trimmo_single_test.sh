#!/bin/bash -l
##Modified by Qiang Lan from Rishi's 4-rna-seq scripts on 20.12.2019

#SBATCH -J test_for_java
#SBATCH --account=Project_2002302 ##*account name must be specified*
#SBATCH -o java_test_out_%j.txt
#SBATCH -e java_test_err_%j.txt
#SBATCH -p large
#SBATCH -n 1 
#SBATCH --cpus-per-task=2 ## *Number of fastq files*  .
#SBATCH -t 02:15:00
#SBATCH --mem-per-cpu=1G 
#SBATCH --mail-type=END

module load openjdk/11.0.2

java -jar $HOME/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads 2 -phred33 sortMeRna/non_rRna_A001_111_ATTACTCG_GCCTCTAT_run20192110N_S1_R1_001.fastq.gz trimmed/trimmed_non_rRna_A001_111_ATTACTCG_GCCTCTAT_run20192110N_S1_R1_001.fastq.gz \
ILLUMINACLIP:$HOME/Trimmomatic-0.39/adapters/TruSeq3-SE.fa:2:30:1 \
#LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
SLIDINGWINDOW:5:20 MINLEN:36
