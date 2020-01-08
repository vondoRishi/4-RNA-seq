#!/bin/bash -l
#Modified by Qiang Lan from Rishi's 4-rna-seq scripts on 20.12.2019
#SBATCH -J fastqc
#SBATCH -o OUT/fastqc_out_%j.txt
#SBATCH -e ERROR/fastqc_err_%j.txt
#SBATCH --account=Project_2002302
#SBATCH -p large 
#SBATCH -n 1
#SBATCH --cpus-per-task=1 ## *Number of fastq files*
#SBATCH -t 12:50:00
#SBATCH --mem-per-cpu=1G
#SBATCH --mail-type=END


source scripts/command_utility.sh
num_cmnds=$( cmnds_in_file )

module load biokit
rm commands/$num_cmnds"_fastqc_"$1_commands.txt

for my_file in $1/*.{fastq,fastq.gz,fq,fq.gz}
do
if [  -f $my_file ]
then
  echo "fastqc -o $1 $my_file " >> commands/$num_cmnds"_fastqc_"$1_commands.txt
fi
done
sbatch_commandlist -t 2:00:00 -mem 3000 -p large -jobname fastqc_array -threads 1  -commands commands/$num_cmnds"_fastqc_"$1_commands.txt


mv *_out_*txt OUT
mv *_err_*txt ERROR

source scripts/multiqc_slurm.sh
# This script will print some usage statistics to the
# end of file: fastqc_out
# Use that to improve your resource request estimate
# on later jobs.
#used_slurm_resources.bash ###not working in the Puhti. Tested by Qiang