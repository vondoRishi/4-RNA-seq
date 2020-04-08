#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J Trimmomatic
#SBATCH -o OUT/Trimmomatic_out_%j.txt
#SBATCH -e ERROR/Trimmomatic_err_%j.txt
#SBATCH -p small
#SBATCH -n 1
#SBATCH -t 01:40:00
#SBATCH --mem-per-cpu=8000
#SBATCH --cpus-per-task=8
#SBATCH --mail-type=END

source scripts/command_utility.sh
module load trimmomatic

echo "trimmomatic" >> version.txt
trimmomatic -version  >> version.txt

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
	echo $filename ;
	echo $extension ;
  echo "trimmomatic SE -phred33 -threads 8  $my_file $2/trimmed_$filename.$extension \
	ILLUMINACLIP:/appl/soft/bio/trimmomatic/Trimmomatic-0.39/adapters/TruSeq3-SE.fa:2:30:10   " >> commands/$num_cmnds"_Trimmomatic_"$1_commands.txt
fi
done
 
	array_msg=$( sbatch_commandlist -t 1:00:00 -mem 4000 -jobname trimo_array -threads 8 -commands commands/$num_cmnds"_Trimmomatic_"$1_commands.txt )

mv *_out_*txt OUT
mv *_err_*txt ERROR

check_array_jobStatus "$array_msg"
