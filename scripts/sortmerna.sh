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

source scripts/command_utility.sh
num_cmnds=$( cmnds_in_file )

module load qiime/1.9.1
  
if [ ! -d "$2" ]
   then
        mkdir "$2"
fi

for my_file in $1/*.{fastq*,fq*}
do
  if [  -f "$my_file" ]
   then
        filename="${my_file##*/}"
        extension="${filename##*.}"
        filename="${filename%.*}"

  echo "sortmerna  --ref $WRKDIR/DONOTREMOVE/Mouse_genome/miscRNA/miscRNA_rRna_id_mouse.fasta,$WRKDIR/DONOTREMOVE/Mouse_genome/miscRNA/miscRNA_rRna_id_mouse.idx --reads $my_file --fastx  -a 8 --aligned $2/rRna_miscRNA_$filename --other $2/no_miscRna_$filename" >> commands/$num_cmnds"_sortmerna_"$1_commands.txt
  
fi
done
sbatch_commandlist -t 12:00:00 -mem 24000 -jobname sortmerna_array -threads 8 -commands commands/$num_cmnds"_sortmerna_"$1_commands.txt
rm -rf $2/rRna_*

mv *_out_*txt OUT
mv *_err_*txt ERROR
# This script will print some usage statistics to the
# end of file: sortmerna_out
# Use that to improve your resource request estimate
# on later jobs.
used_slurm_resources.bash
