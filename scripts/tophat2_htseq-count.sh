#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J htseq
#SBATCH -o OUT/htseq_out_%j.txt
#SBATCH -e ERROR/htseq_err_%j.txt
#SBATCH -p large 
#SBATCH -n 2
#SBATCH -t 22:20:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-type=END

source scripts/command_utility.sh
num_cmnds=$( cmnds_in_file )

module load biokit

for my_file in $1/*
do
if [ -d "$my_file" ]
then
	filename="${my_file##*/}"
        extension="${filename##*.}"
        filename="${filename%%.*}" 
  echo "samtools view $my_file/accepted_hits.bam | htseq-count -s reverse -t exon -i gene_id - $WRKDIR/DONOTREMOVE/Mouse_genome/Mus_musculus.GRCm38.79.gtf > $1/htseq_ensemble_reverse_$filename.txt" >> commands/$num_cmnds"_htseq_"$1_commands.txt

fi
done
sbatch_commandlist -t 22:00:00 -mem 8000 -jobname htseq_array -threads 1 -commands  commands/$num_cmnds"_htseq_"$1_commands.txt


mv *_out_*txt OUT
mv *_err_*txt ERROR

source scripts/multiqc_slurm.sh $1
