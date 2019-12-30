#!/bin/bash -l
#Created by Qiang Lan at 24.12.2019
#SBATCH -J Tar_archieve_files
#SBATCH -o Tar_achieve_out_%j.txt
#SBATCH -e Tar_achieve_err_%j.txt
#SBATCH --account=Project_2002302
#SBATCH -p large 
#SBATCH -n 1
#SBATCH --cpus-per-task=8 ##
#SBATCH -t 48:50:00
#SBATCH --mem-per-cpu=4G
#SBATCH --mail-type=END



tar -xvf $1 
