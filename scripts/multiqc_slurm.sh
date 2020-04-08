#!/bin/bash
#SBATCH -J multiqc
#SBATCH -o OUT/multiqc_out_%j.txt
#SBATCH -e ERROR/multiqc_err_%j.txt
#SBATCH -t 48:00:00
#SBATCH --mem=4000
#SBATCH -n 1
#SBATCH -p small 
#SBATCH --mail-type=END

source scripts/command_utility.sh

module load bioconda

if [ -d "$1" ]
then
	multiqc -f $1 -o $1 -n $1
fi

if [ ! -d "$1" ]
then
	multiqc -i $project_name -n $project_name -f .
fi
