#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J sortmerna
#SBATCH -o OUT/sortmerna_out_%j.txt
#SBATCH -e ERROR/sortmerna_err_%j.txt
#SBATCH -p large
#SBATCH -n 1
#SBATCH -t 12:20:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-type=END

source scripts/command_utility.sh
source scripts/sortMeRNA_indexdb.sh

module load bioconda
source activate qiime2-2019.7

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

  echo "zcat $my_file > $1/$filename" >> commands/$num_cmnds"_gunzipSortMeRNA_"$1_commands.txt
  
fi
done

sbatch_commandlist -t 12:00:00 -mem 24000 -jobname sortmerna_array -threads 8 -commands commands/$num_cmnds"_gunzipSortMeRNA_"$1_commands.txt


num_cmnds=$( cmnds_in_file )

for my_file in $1/*.{fastq,fq}
do
  if [  -f "$my_file" ]
   then
        filename="${my_file##*/}"
        extension="${filename##*.}"
        filename="${filename%.*}"

  echo "sortmerna  --ref  $sortMeRNA_ref,$index_file --reads $my_file \
	--aligned $2/rRna_$filename --other $2/non_rRna_$filename \
	--sam --SQ --log -v  --fastx  -a 8 " >> commands/$num_cmnds"_sortmerna_"$1_commands.txt
  
fi
done
 sbatch_commandlist -t 12:00:00 -mem 24000 -jobname sortmerna_array -threads 8 -commands commands/$num_cmnds"_sortmerna_"$1_commands.txt


rm -rf $2/rRna_*{fastq,fq}

rm -rf $1/*.fq

mv *_out_*txt OUT
mv *_err_*txt ERROR
