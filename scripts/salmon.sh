#!/bin/bash -l
# author: dasroy
#SBATCH -J salmon
#SBATCH -o OUT/salmon_out_%j.txt
#SBATCH -e ERROR/salmon_err_%j.txt
#SBATCH -p small
#SBATCH -n 1
#SBATCH -t 12:00:00
#SBATCH --mem=4000
#SBATCH --mail-type=END

source scripts/command_utility.sh
num_cmnds=$( cmnds_in_file )

module load salmon/0.99.0b2
salmon --version >> version.txt

## Starting Indexing the genome
	
if [ ! -d $2 ]; then

	echo "salmon index -t $transcripts -i $2" >> commands/$num_cmnds"_"$2_commands.txt 

	sbatch_commandlist -t 12:00:00 -mem 12000 -jobname salmon-indexing \
	-threads 6  -commands commands/$num_cmnds"_"$2_commands.txt 

	mv *_out_*txt OUT
	mv *_err_*txt ERROR
fi
## Finished Indexing the genome 


## Alignment of each fastq file starts here

for my_file in $1/*.{fastq,fastq.gz,fq,fq.gz}
do
  if [  -f "$my_file" ]
   then
        filename="${my_file##*/}"
        extension="${filename##*.}"
        filename="${filename%.*}"
	
  	echo "salmon quant -i $2 -l A -r $my_file -g $gene_annotation \
		-p 4 --validateMappings -o $3/${filename}_quant " >> commands/$num_cmnds"_"$2_$3_commands.txt
fi
done

sbatch_commandlist -t 12:00:00 -mem 12000 -jobname salmon_quant \
-threads 4 -commands commands/$num_cmnds"_"$2_$3_commands.txt

mv *_out_*txt OUT
mv *_err_*txt ERROR

source scripts/multiqc_slurm.sh $3

