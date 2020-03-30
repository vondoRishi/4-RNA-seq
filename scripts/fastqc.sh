#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J fastqc
#SBATCH -o OUT/fastqc_out_%j.txt
#SBATCH -e ERROR/fastqc_err_%j.txt
#SBATCH -p small
#SBATCH -n 1
#SBATCH -t 02:50:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-type=END

source scripts/command_utility.sh
num_cmnds=$( cmnds_in_file )

module load biokit
fastqc -v >> "version.txt"
rm commands/$num_cmnds"_fastqc_"$1_commands.txt

for my_file in $1/*.{fastq,fastq.gz,fq,fq.gz}
do
if [  -f $my_file ]
then
  echo "fastqc -o $1 $my_file " >> commands/$num_cmnds"_fastqc_"$1_commands.txt
fi
done
sbatch_commandlist -t 2:00:00 -mem 4000 -jobname fastqc_array -threads 1  -commands commands/$num_cmnds"_fastqc_"$1_commands.txt


mv *_out_*txt OUT
mv *_err_*txt ERROR

source scripts/multiqc_slurm.sh
