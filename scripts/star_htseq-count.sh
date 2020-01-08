#!/bin/bash -l
##Modified by Qiang Lan from Rishi's 4-rna-seq scripts on 21.12.2019
#SBATCH -J htseq
#SBATCH --account=Project_2002302 ##*account name must be specified*
#SBATCH -o OUT/htseq_out_%j.txt
#SBATCH -e ERROR/htseq_err_%j.txt
#SBATCH -p large
#SBATCH -n 1 
#SBATCH -t 48:15:00
#SBATCH --mem-per-cpu=1G 
#SBATCH --mail-type=END

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
  
	echo "htseq-count -f bam -s $stranded -t exon -i gene_id \
              $my_file $gene_annotation > \
	$2/htseq_ensemble_gtf_$filename.txt" >> commands/$num_cmnds"_htseq_"$2.txt

fi
done
sbatch_commandlist -p large -t 12:00:00 -mem 4000 -jobname htseq_star -threads 2 -commands  commands/$num_cmnds"_htseq_"$2.txt

mv *_out_*txt OUT
mv *_err_*txt ERROR

source scripts/multiqc_slurm.sh $2
# This script will print some usage statistics to the
# end of file: htseq_out
# Use that to improve your resource request estimate
# on later jobs.
###used_slurm_resources.bash