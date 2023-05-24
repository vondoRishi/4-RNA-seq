#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J htseq
#SBATCH -o OUT/htseq_out_%j.txt
#SBATCH -e ERROR/htseq_err_%j.txt
#SBATCH -p large
#SBATCH -n 2
#SBATCH -t 12:20:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-type=END


source scripts/command_utility.sh

  if [ ! -d "$2" ]
   then
        mkdir $2
   fi

module load biopythontools/11.3.0_3.10.6 
htseq-count --version >> version.txt

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

array_msg=$( sbatch_commandlist -t 12:00:00 -mem 4000 -jobname htseq_star -threads 1 -commands  commands/$num_cmnds"_htseq_"$2.txt )

mv *_out_*txt OUT
mv *_err_*txt ERROR

check_array_jobStatus "$array_msg"

source scripts/multiqc_slurm.sh $2
