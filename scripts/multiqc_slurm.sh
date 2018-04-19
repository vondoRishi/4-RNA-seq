#!/bin/bash
#SBATCH -J multiqc
#SBATCH -o OUT/multiqc_out_%j.txt
#SBATCH -e ERROR/multiqc_err_%j.txt
#SBATCH -t 48:00:00
#SBATCH --mem=4000
#SBATCH -n 1
#SBATCH -p serial
#SBATCH --mail-type=END

module load biopython-env

export PYTHONPATH=/homeappl/home/dasroy/.local/lib/python2.7/site-packages

export PATH=/homeappl/home/dasroy/.local/bin:$PATH

if [ -d "$1" ]
then
	multiqc -f -d $1 -o $1
fi

if [ ! -d "$1" ]
then
	multiqc -f -d .
fi
