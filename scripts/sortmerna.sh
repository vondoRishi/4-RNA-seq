#!/bin/bash -l
#Modified by Qiang Lan from Rishi's 4-rna-seq scripts on 20.12.2019
#SBATCH -J sortmerna
#SBATCH -o OUT/sortmerna_out_%j.txt
#SBATCH -e ERROR/sortmerna_err_%j.txt
#SBATCH --account=Project_2002302
#SBATCH -p large 
#SBATCH -n 1
#SBATCH --cpus-per-task=8 ## *Number of fastq files*
#SBATCH -t 48:50:00
#SBATCH --mem-per-cpu=4G
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

sbatch_commandlist -t 12:00:00 -p large -mem 2G -jobname gunzip_sortmerna_array -threads 2 -commands commands/$num_cmnds"_gunzipSortMeRNA_"$1_commands.txt

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
	--sam --SQ --log -v  --fastx  -a $SLURM_CPUS_PER_TASK " >> commands/$num_cmnds"_sortmerna_"$1_commands.txt
	
  
fi
done
sbatch_commandlist -t 12:00:00 -p large -mem 4G -jobname sortmerna_array -threads 8 -commands commands/$num_cmnds"_sortmerna_"$1_commands.txt


rm -rf $2/rRna_*{fastq,fq}

rm -rf $1/*.{fastq,fq}

mv *_out_*txt OUT  
mv *_err_*txt ERROR
# This script will print some usage statistics to the
# end of file: sortmerna_out
# Use that to improve your resource request estimate
# on later jobs.
#used_slurm_resources.bash  # in nex system this script is not working anymore

#efficicency need to bo tested later
#sleep 5                                 # wait for slurm to get the job status into its database
#sacct --format=JobID,Submit,Start,End,State,Partition,ReqTRES%30,CPUTime,MaxRSS,NodeList%30 --units=M -j $SLURM_JOBID

