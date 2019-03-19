#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J htseq
#SBATCH --constraint="snb|hsw"
#SBATCH -o OUT/htseq_out_%j.txt
#SBATCH -e ERROR/htseq_err_%j.txt
#SBATCH -p serial
#SBATCH -n 1
#SBATCH -t 12:20:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-type=END
#SBATCH --mail-user=rishi.dasroy@helsinki.fi

source scripts/command_utility.sh

  if [ ! -d "$2" ]
   then
        mkdir $2
   fi

module load biokit
for my_file in $1/*.bam
do
if [ -f "$my_file" ]
then
	filename="${my_file##*/}"
        extension="${filename##*.}"
        filename="${filename%%.*}" 
  
	echo "samtools view $my_file | \
	htseq-count -s $stranded -t exon -i gene_id - $gene_annotation > \
	$2/htseq_ensemble_gtf_$filename.txt" >> commands/$num_cmnds"_htseq_"$2.txt

fi
done
sbatch_commandlist -t 12:00:00 -mem 4000 -jobname htseq_star -threads 1 -commands  commands/$num_cmnds"_htseq_"$2.txt

mv *_out_*txt OUT
mv *_err_*txt ERROR

source scripts/multiqc_slurm.sh
# This script will print some usage statistics to the
# end of file: htseq_out
# Use that to improve your resource request estimate
# on later jobs.
used_slurm_resources.bash
