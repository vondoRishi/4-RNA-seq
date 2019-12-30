#!/bin/bash -l
#Modified by Qiang Lan from Rishi's 4-rna-seq scripts on 20.12.2019
#SBATCH -J sortmerna_V4
#SBATCH --account=Project_2002302 ##*account name must be specified*
#SBATCH -o OUT/sortmerna_V4_out_%j.txt
#SBATCH -e ERROR/sortmerna_V4_err_%j.txt
#SBATCH -p large
#SBATCH -n 1 
#SBATCH --cpus-per-task=3 ## *Number of fastq files*  ## 1,2,4 have been tested. 1,2 efficiency  > 95%, 4 take 78%.
#SBATCH -t 12:15:00
#SBATCH --mem-per-cpu=2G ##2G is enought for each one. ONLY 2 G will be used even 16G provided
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

  echo "sortmerna  -ref  $sortMeRNA_ref --reads $my_file \
  -workdir ./ -other -sam -SQ -fastx --pid -m 4000  -a $SLURM_CPUS_PER_TASK " >> commands/$num_cmnds"_sortmerna_"$1_commands.txt
	
  
fi
done
sbatch_commandlist -t 12:00:00 -p large -mem 24G -jobname sortmerna_array -threads 8 -commands commands/$num_cmnds"_sortmerna_"$1_commands.txt


rm -rf $2/*aligned*{fastq,fq,fasta}
rm -rf ./kvdb/

#rm -rf $1/*.{fastq,fq}

mv *_out_*txt OUT  #may got error if sbatch_commandlist not in use.
mv *_err_*txt ERROR
# This script will print some usage statistics to the
# end of file: sortmerna_out

