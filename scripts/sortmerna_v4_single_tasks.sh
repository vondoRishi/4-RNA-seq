#!/bin/bash -l
#Modified by Qiang Lan from Rishi's 4-rna-seq scripts on 20.12.2019
#SBATCH -J sortmerna_V4_single
#SBATCH --account=Project_2002302 ##*account name must be specified*
#SBATCH -o OUT/sortmerna_V4_single_out_%j.txt
#SBATCH -e ERROR/sortmerna_V4_err_single_%j.txt
#SBATCH -p large
#SBATCH -n 1 
#SBATCH --cpus-per-task=8 ## *Number of fastq files*  .
#SBATCH -t 70:15:00
#SBATCH --mem-per-cpu=4G ##
#SBATCH --mail-type=END


source scripts/command_utility.sh

if [ ! -d "$2" ]
   then
        mkdir $2
fi

for my_file in $1/*.{fastq,fq,fastq.gz,fq.gz}
do
  if [  -f "$my_file" ]
   then
        filename="${my_file##*/}"
        extension="${filename##*.}"
        filename="${filename%.*}"
  
  ##keep the record of the command 
  echo "sortmerna  -ref  $sortMeRNA_ref --reads $my_file \
  -workdir ./$2 -other -sam -SQ -fastx -m 4000  -a $SLURM_CPUS_PER_TASK " >> commands/$num_cmnds"_sortmerna_"$1_commands.txt
  # sortmerna v4 running.
  #echo "Start processing $my_file"
  sortmerna  -ref  $sortMeRNA_ref --reads $my_file \
  -workdir $2 -other -sam -SQ -fastx  -m 4000  -a $SLURM_CPUS_PER_TASK 
  
  mv $2/out/aligned.log $2/non_rRna_$filename.log
  mv $2/out/other.fastq $2/non_rRna_$filename.fastq
  rm -rf $2/aligned.{fastq,fq}
  rm -rf $2/kvdb/
  
  #echo "$my_file done!"
	
  
fi
done



