#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J sortmerna
#SBATCH -o OUT/sortmerna_out_%j.txt
#SBATCH -e ERROR/sortmerna_err_%j.txt
#SBATCH -p small
#SBATCH -n 1
#SBATCH -t 12:20:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-type=END

source scripts/command_utility.sh
# source scripts/sortMeRNA_indexdb.sh
num_cmnds=$( cmnds_in_file )

module load bioconda
source activate qiime2-2019.7
sortmerna --version >>  version.txt

if [ ! -d "$2" ]
   then
        mkdir "$2"
fi


for my_file in $1/*.{fastq.gz,fq.gz}
do
  if [  -f "$my_file" ]
   then
        filename="${my_file##*/}"
        extension="${filename##*.}"
        filename="${filename%.*}"

  echo "bash scripts/custom_sortmerna.sh $1 $2 $my_file  " >> commands/$num_cmnds"_gunzipSortMeRNA_"$1_commands.txt
#  echo "zcat $my_file > $1/$filename" >> commands/$num_cmnds"_gunzipSortMeRNA_"$1_commands.txt
  
fi
done

 sbatch_commandlist -max_running 10 -t 12:00:00 -mem 24000 -jobname sortmerna_array -threads 8 -commands commands/$num_cmnds"_gunzipSortMeRNA_"$1_commands.txt


mv *_out_*txt OUT
mv *_err_*txt ERROR
