#!/bin/bash -l
#Modified by Qiang Lan from Rishi's 4-rna-seq scripts on 20.12.2019
#SBATCH -J compress
#SBATCH -o OUT/compress_out_%j.txt
#SBATCH -e ERROR/compress_err_%j.txt
#SBATCH --account=Project_2002302
#SBATCH -p large 
#SBATCH -n 1
#SBATCH --cpus-per-task=1 ## *Number of fastq files*
#SBATCH -t 12:50:00
#SBATCH --mem-per-cpu=1G
#SBATCH --mail-type=END

source scripts/command_utility.sh
num_cmnds=$( cmnds_in_file )

module load biokit

for my_file in $1/*.{fastq,fq}
do
if [  -f $my_file ]
then

	echo "gzip  $my_file " >> commands/$num_cmnds"_compress_"$1.txt
	
fi
done
sbatch_commandlist -t 12:00:00 -p large -mem 1000 -jobname compress_array -threads 2 -commands  commands/$num_cmnds"_compress_"$1.txt

mv *_out_*txt OUT
mv *_err_*txt ERROR
# This script will print some usage statistics to the
# end of file: compress_out
# Use that to improve your resource request estimate
# on later jobs.
#used_slurm_resources.bash  ##not working in the Puhti. Tested by Qiang