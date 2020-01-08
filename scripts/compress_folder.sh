#!/bin/bash -l
##created by Qiang on 21.12.2019
#SBATCH -J Compress_archieve_folder
#SBATCH --account=Project_2002302 ##*account name must be specified*
#SBATCH -o folder_compress_out_%j.txt
#SBATCH -e folder_compress_err_%j.txt
#SBATCH -p large
#SBATCH -n 1 
#SBATCH -t 48:15:00
#SBATCH --cpus-per-task=5
#SBATCH --mem-per-cpu=4G 
#SBATCH --mail-type=END


tar -pczf $1 $2 --exclude="$2/star-genome_ann_Indices"


