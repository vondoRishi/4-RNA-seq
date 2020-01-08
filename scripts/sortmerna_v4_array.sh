#!/bin/bash -l
#Modified by Qiang Lan from Rishi's 4-rna-seq scripts on 20.12.2019
#SBATCH -J sortmerna_V4_array
#SBATCH --account=Project_2002302 ##*account name must be specified*
#SBATCH -o OUT/sortmerna_V4_array_out_%A_%a.txt
#SBATCH -e ERROR/sortmerna_V4_array_err_%A_%a.txt
#SBATCH -p large
#SBATCH -n 1 
#SBATCH --cpus-per-task=6 ## *Number of fastq files*  .
#SBATCH -t 70:15:00
#SBATCH --mem-per-cpu=2G ##
#SBATCH --mail-type=END
#SBATCH --array=1-25

source scripts/command_utility.sh

export PATH=/projappl/project_2002302/sortmerna-4.0.0-Linux/bin:$PATH  #activate the sortmerna_v4.0

my_file=$(sed -n ${SLURM_ARRAY_TASK_ID}p namelist)

#my_prog ${name} ${name}.out

if [ ! -d "$1" ]
   then
        mkdir $1
fi


if [  -f "$my_file" ]
   then
        filename="${my_file##*/}"
        extension="${filename##*.}"
        filename="${filename%.*}"
        
  mkdir $1/sortmerna_v4_$SLURM_ARRAY_TASK_ID 
  cp -r $index_files $1/sortmerna_v4_$SLURM_ARRAY_TASK_ID/ 
  
  ##keep the record of the command 
  echo "sortmerna  -ref  $sortMeRNA_ref --reads $my_file \
  -workdir $1/sortmerna_v4_$SLURM_ARRAY_TASK_ID -other -sam -SQ -fastx -m 4000  -a $SLURM_CPUS_PER_TASK " >> commands/$num_cmnds"_sortmerna_V4_array"_$SLURM_ARRAY_JOB_ID_$SLURM_ARRAY_TASK_ID_commands.txt
  # sortmerna v4 running.
  #echo "Start processing $my_file"
  sortmerna  -ref  $sortMeRNA_ref --reads $my_file \
  -workdir $1/sortmerna_v4_$SLURM_ARRAY_TASK_ID -other -sam -SQ -fastx  -m 4000  -a $SLURM_CPUS_PER_TASK 
  
  mv $1/sortmerna_v4_$SLURM_ARRAY_TASK_ID/out/aligned.log $1/rRna_$filename.log
  mv $1/sortmerna_v4_$SLURM_ARRAY_TASK_ID/out/other.fastq $1/non_rRna_$filename.fastq
  mv $1/sortmerna_v4_$SLURM_ARRAY_TASK_ID/out/aligned.sam $1/rRna_$filename.sam
  rm -rf $1/sortmerna_v4_$SLURM_ARRAY_TASK_ID
  
  #echo "$my_file done!"
fi




