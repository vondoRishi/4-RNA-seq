#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J htseq
#SBATCH --constraint="snb|hsw"
#SBATCH -o OUT/htseq_out_%j.txt
#SBATCH -e ERROR/htseq_err_%j.txt
#SBATCH -p serial
#SBATCH -n 1
#SBATCH -t 22:20:00
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
rm -rf commands/htseq_$1_commands.txt

for my_file in $1/*
do
if [ -d "$my_file" ]
then
	filename="${my_file##*/}"
        extension="${filename##*.}"
        filename="${filename%%.*}" 
  echo "samtools view $my_file/accepted_hits.bam | htseq-count -s reverse -t exon -i gene_id - $WRKDIR/DONOTREMOVE/Mouse_genome/Mus_musculus.GRCm38.79.gtf > $1/htseq_ensemble_reverse_$filename.txt" >> commands/htseq_$1_commands.txt

fi
done
sbatch_commandlist -t 22:00:00 -mem 8000 -jobname htseq_array -threads 1 -commands  commands/htseq_$1_commands.txt

# This script will print some usage statistics to the
# end of file: htseq_out
# Use that to improve your resource request estimate
# on later jobs.
used_slurm_resources.bash
