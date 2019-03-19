#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J Trimmomatic
#SBATCH --constraint="snb|hsw"
#SBATCH -o OUT/Trimmomatic_out_%j.txt
#SBATCH -e ERROR/Trimmomatic_err_%j.txt
#SBATCH -p serial
#SBATCH -n 1
#SBATCH -t 01:40:00
#SBATCH --mem-per-cpu=8000
#SBATCH --cpus-per-task=8
#SBATCH --mail-type=END

source scripts/command_utility.sh


  if [ ! -d $2 ]
   then
	mkdir $2
   fi

for my_file in $1/*.{fastq*,fq,fq.gz}
do
	filename="${my_file##*/}"
	extension="${filename##*.}"
	filename="${filename%.*}"
	echo $filename ;
	echo $extension ;
  echo "trimmomatic SE -phred33 -threads 8  $my_file $2/trimmed_$filename.$extension \
	ILLUMINACLIP:/appl/bio/trimmomatic/adapters/TruSeq3-SE.fa:2:30:10   " >> commands/$num_cmnds"_Trimmomatic_"$1_commands.txt
done
 
	sbatch_commandlist -t 1:00:00 -mem 4000 -jobname trimo_array -threads 8 -commands commands/$num_cmnds"_Trimmomatic_"$1_commands.txt

mv *_out_*txt OUT
mv *_err_*txt ERROR
# This script will print some usage statistics to the
# end of file: Trimmomatic_out
# Use that to improve your resource request estimate
# on later jobs.
used_slurm_resources.bash
