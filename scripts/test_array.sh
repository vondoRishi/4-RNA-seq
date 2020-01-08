#!/bin/bash -l
#Modified by Qiang Lan from Rishi's 4-rna-seq scripts on 20.12.2019
#SBATCH -J array test
#SBATCH --account=Project_2002302 ##*account name must be specified*
#SBATCH -o test_array_out_%A_%a.txt
#SBATCH -e test_array_err_%A_%a.txt
#SBATCH -p large
#SBATCH -n 1 
#SBATCH --cpus-per-task=1 ## *Number of fastq files*  .
#SBATCH -t 70:15:00
#SBATCH --mem-per-cpu=200 ##
#SBATCH --mail-type=END
#SBATCH --array=1-50

name=$(sed -n ${SLURM_ARRAY_TASK_ID}p namelist)

my_prog ${name} ${name}.out