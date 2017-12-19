#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J STAR
#SBATCH -o OUT/STAR_out_%j.txt
#SBATCH -e ERROR/STAR_err_%j.txt
#SBATCH -n 1
#SBATCH -t 03:20:00
#SBATCH --mem=1000
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
rm -rf commands/STAR_$1_commands.txt
  if [ ! -d $2 ]
   then
        mkdir $2
   fi

for my_file in $1/*.{fastq*,fq}
do
  if [  -f $my_file ]
   then
        filename="${my_file##*/}"
        extension="${filename##*.}"
        filename="${filename%.*}"

  echo "STAR --genomeDir $WRKDIR/DONOTREMOVE/Project/star-genome --readFilesIn  $my_file  --outFileNamePrefix $2/star_$filename --outSAMtype BAM SortedByCoordinate --runThreadN 4" >> commands/STAR_$1_commands.txt
fi
done
sbatch_commandlist -t 12:00:00 -mem 36000 -jobname STAR_array -threads 4 -commands commands/STAR_$1_commands.txt

# This script will print some usage statistics to the
# end of file: STAR_out
# Use that to improve your resource request estimate
# on later jobs.
used_slurm_resources.bash
