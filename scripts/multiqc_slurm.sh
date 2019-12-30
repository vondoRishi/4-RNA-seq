#!/bin/bash -l
#Modified by Qiang Lan from Rishi's 4-rna-seq scripts on 20.12.2019
#SBATCH -J multiqc
#SBATCH -o OUT/multiqc_out_%j.txt
#SBATCH -e ERROR/multiqc_err_%j.txt
#SBATCH --account=Project_2002302
#SBATCH -p large 
#SBATCH -n 1
#SBATCH --cpus-per-task=1 ## *Number of fastq files*
#SBATCH -t 02:15:00
#SBATCH --mem-per-cpu=1G
#SBATCH --mail-type=END


source scripts/command_utility.sh

module load bioconda
source activate python3-env

if [ -d "$1" ]
then
	multiqc -f $1 -o $1 -n $1 -c scripts/multiqc_config.yaml
fi

if [ ! -d "$1" ]
then
	multiqc -i $project_name -n $project_name -c scripts/multiqc_config.yaml -f .
fi