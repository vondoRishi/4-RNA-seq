#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J afterqc
#SBATCH -o OUT/afterqc_out_%j.txt
#SBATCH -e ERROR/afterqc_err_%j.txt
#SBATCH -p large
#SBATCH -n 1
#SBATCH -t 04:20:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-type=END

source scripts/command_utility.sh
num_cmnds=$( cmnds_in_file )

module load biokit
if [ -d good ]
then
        mkdir good bad QC
fi

for my_file in $1/*.{fastq,fastq.gz,fq,fq.gz}
do
if [  -f $my_file ]
then
  echo " python $AfterQC/after.py  -1 $my_file " >> commands/$num_cmnds"_afterqc_"$1_commands.txt
fi
done
sbatch_commandlist -t 4:00:00 -mem 4000 -jobname afterqc_array -threads 1  -commands commands/$num_cmnds"_afterqc_"$1_commands.txt


mv *_out_*txt OUT
mv *_err_*txt ERROR

