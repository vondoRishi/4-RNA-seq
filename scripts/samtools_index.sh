#!/bin/bash -l
##Modified by Qiang Lan from Rishi's 4-rna-seq scripts on 22.12.2019
#SBATCH -J samtools
#SBATCH --account=Project_2002302 ##*account name must be specified*
#SBATCH -o OUT/samtools_out_%j.txt
#SBATCH -e ERROR/samtools_err_%j.txt
#SBATCH -p large
#SBATCH -n 1 
#SBATCH -t 48:15:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G 
#SBATCH --mail-type=END

source scripts/command_utility.sh

module load biokit

for my_file in $1/*bam
do
if [  -f $my_file ]
then
	# needed for tophat
	# echo "samtools sort -m 4000 $my_file $my_file_sorted " >> commands/samtools_$1_commands.txt
	echo "samtools index  $my_file " >> commands/$num_cmnds"_samtools_"$1.txt
fi
done

sbatch_commandlist -p large -t 12:00:00 -mem 4000 -jobname samtools_array -threads 4 -commands  commands/$num_cmnds"_samtools_"$1.txt


mv *_out_*txt OUT
mv *_err_*txt ERROR
# This script will print some usage statistics to the
# end of file: samtools_out
# Use that to improve your resource request estimate
# on later jobs.
##used_slurm_resources.bash