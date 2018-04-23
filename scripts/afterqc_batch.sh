#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J afterqc
#SBATCH --constraint="snb|hsw"
#SBATCH -o OUT/afterqc_out_%j.txt
#SBATCH -e ERROR/afterqc_err_%j.txt
#SBATCH -p serial
#SBATCH -n 1
#SBATCH -t 04:20:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-type=END

source scripts/command_utility.sh
num_cmnds=$( cmnds_in_file )

module load biokit

for my_file in $1/*.{fastq*,fq}
do
if [  -f $my_file ]
then
  echo " python $USERAPPL/AfterQC-master/after.py  -1 $my_file " >> commands/$num_cmnds"_afterqc_"$1_commands.txt
fi
done
sbatch_commandlist -t 4:00:00 -mem 4000 -jobname afterqc_array -threads 1  -commands commands/$num_cmnds"_afterqc_"$1_commands.txt


mv *_out_*txt OUT
mv *_err_*txt ERROR

# This script will print some usage statistics to the
# end of file: afterqc_out
# Use that to improve your resource request estimate
# on later jobs.
used_slurm_resources.bash
