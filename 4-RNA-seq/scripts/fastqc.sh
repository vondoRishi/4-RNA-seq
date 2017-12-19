#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J fastqc
#SBATCH --constraint="snb|hsw"
#SBATCH -o OUT/fastqc_out_%j.txt
#SBATCH -e ERROR/fastqc_err_%j.txt
#SBATCH -p serial
#SBATCH -n 1
#SBATCH -t 00:20:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-type=END

# commands to manage the batch script
#   submission command
#     sbatch [script-file]
#   status command
#     squeue -u dasroy
#   termination command
#     scancel [jobid]

# For more information
#   man sbatch
#   more examples in Taito guide in
#   http://research.csc.fi/taito-user-guide

# example run commands
module load biokit
rm commands/fastqc_$1_commands.txt

for my_file in $1/*.{fastq*,fq*}
do
if [  -f $my_file ]
then
  echo "fastqc -o $1 $my_file " >> commands/fastqc_$1_commands.txt
fi
done
sbatch_commandlist -t 1:00:00 -mem 4000 -jobname fastqc_array -threads 1  -commands commands/fastqc_$1_commands.txt

# This script will print some usage statistics to the
# end of file: fastqc_out
# Use that to improve your resource request estimate
# on later jobs.
used_slurm_resources.bash
