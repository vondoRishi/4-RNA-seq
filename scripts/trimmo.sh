#!/bin/bash -l
##Modified by Qiang Lan from Rishi's 4-rna-seq scripts on 20.12.2019

#SBATCH -J trimmo
#SBATCH --account=Project_2002302 ##*account name must be specified*
#SBATCH -o OUT/Trimmomatic_out_%j.txt
#SBATCH -e ERRO/Trimmomatic_err_%j.txt
#SBATCH -p large
#SBATCH -n 1 
#SBATCH --cpus-per-task=1
#SBATCH -t 12:15:00
#SBATCH --mem-per-cpu=1000 
#SBATCH --mail-type=END

module load openjdk/11.0.2
source scripts/command_utility.sh

  if [ ! -d $2 ]
   then
	mkdir $2
   fi

for my_file in $1/*.{fastq,fastq.gz,fq,fq.gz}
do
if [ -f $my_file ]
then
	filename="${my_file##*/}"
	extension="${filename##*.}"
	filename="${filename%.*}"
	adaptor_loc="${trimmo_path%/*}"
	echo $filename ;
	echo $extension ;
  echo "java -jar $trimmo_path SE -phred33 -threads 2  $my_file $2/trimmed_$filename.$extension \
	ILLUMINACLIP:$adaptor_loc/adapters/TruSeq3-SE.fa:2:30:10 SLIDINGWINDOW:5:20 MINLEN:36 " >> commands/$num_cmnds"_Trimmomatic_"$1_commands.txt
fi
done
 
    sbatch_commandlist -t 1:00:00 -p large -mem 3G -jobname trimmo_array -threads 3 -commands commands/$num_cmnds"_Trimmomatic_"$1_commands.txt

mv *_out_*txt OUT
mv *_err_*txt ERROR
# This script will print some usage statistics to the
# end of file: Trimmomatic_out
# Use that to improve your resource request estimate
# on later jobs.
##used_slurm_resources.bash
 
