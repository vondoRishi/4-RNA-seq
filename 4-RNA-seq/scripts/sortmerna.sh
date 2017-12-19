#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J sortmerna
#SBATCH --constraint="snb|hsw"
#SBATCH -o OUT/sortmerna_out_%j.txt
#SBATCH -e ERROR/sortmerna_err_%j.txt
#SBATCH -p serial
#SBATCH -n 1
#SBATCH -t 12:20:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-type=END

# commands to manage the batch script
#   submission command
#     sbatch [script-file]
#   status command
#     squeue -u dasroy
#   termination command
#     scancel [jobid]

## SBATCH --cpus-per-task=4
# For more information
#   man sbatch
#   more examples in Taito guide in
#   http://research.csc.fi/taito-user-guide

# example run commands
module load qiime/1.9.1
rm -rf commands/sortmerna_$1_commands.txt
  if [ ! -d "$2" ]
   then
        mkdir "$2"
   fi
for my_file in $1/*.{fastq*,fq}
do
  if [  -f "$my_file" ]
   then
        filename="${my_file##*/}"
        extension="${filename##*.}"
        filename="${filename%.*}"

  echo "sortmerna  --ref /wrk/dasroy/DONOTREMOVE/Mouse_genome/miscRNA/miscRNA_rRna_id_mouse.fasta,/wrk/dasroy/DONOTREMOVE/Mouse_genome/miscRNA/miscRNA_rRna_id_mouse.idx --reads $my_file --fastx  -a 8 --aligned $2/rRna_miscRNA_$filename --other $2/no_miscRna_$filename" >> commands/sortmerna_$1_commands.txt
  
fi
done
sbatch_commandlist -t 12:00:00 -mem 24000 -jobname sortmerna_array -threads 8 -commands commands/sortmerna_$1_commands.txt
rm -rf $2/rRna_*

# This script will print some usage statistics to the
# end of file: sortmerna_out
# Use that to improve your resource request estimate
# on later jobs.
used_slurm_resources.bash
