#!/bin/bash -l
##Modified by Qiang Lan from Rishi's 4-rna-seq scripts on 21.12.2019
#SBATCH -J STAR_alignment
#SBATCH --account=Project_2002302 ##*account name must be specified*
#SBATCH -o OUT/Star_out_%j.txt
#SBATCH -e ERROR/Star_err_%j.txt
#SBATCH -p large
#SBATCH -n 1 
#SBATCH -t 48:15:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G 
#SBATCH --mail-type=END

module load biokit
source scripts/command_utility.sh
num_cmnds=$( cmnds_in_file )

## Starting Indexing the genome

##there is a bug, if the first time without indexing, the aligment in the next step will still runding but failed. should be better
# to add one if condition to check tht index file.
if [ ! -d star-genome_ann_Indices ]; then
	
	mkdir star-genome_ann_Indices
	overhang=$(( maxReadLength - 1 ))

	echo "STAR --runMode genomeGenerate --genomeDir star-genome_ann_Indices \
		--genomeFastaFiles $genome_file --sjdbGTFfile  $gene_annotation \
		--runThreadN 6 --sjdbOverhang $overhang" >> commands/$num_cmnds"_star-genome_annotated".txt 

	sbatch_commandlist -p large -t 12:00:00 -mem 48000 -jobname star-indexing \
	-threads 5  -commands commands/$num_cmnds"_star-genome_annotated".txt 

	mv *_out_*txt OUT
	mv *_err_*txt ERROR

fi
## Finished Indexing the genome 


## Alignment of each fastq file starts here
  if [ ! -d "$2" ]
   then
        mkdir $2
   fi

for my_file in $1/*.{fastq,fastq.gz,fq,fq.gz}
do
  if [  -f "$my_file" ]
   then
        filename="${my_file##*/}"
        extension="${filename##*.}"
        filename="${filename%.*}"
	
	uncompress=""
	if [ "$extension" == "gz" ]
	then
		uncompress="--readFilesCommand zcat"
	fi 


  	echo "STAR --genomeDir star-genome_ann_Indices --readFilesIn  $my_file $uncompress \
		--outFileNamePrefix $2/star_annotated_$filename \
		--outSAMtype BAM SortedByCoordinate --runThreadN 4" >> commands/$num_cmnds"_STAR_align_"$1_commands.txt
fi
done

sbatch_commandlist -p large -t 12:00:00 -mem 48000 -jobname STAR_alignment_array \
-threads 4 -commands commands/$num_cmnds"_STAR_align_"$1_commands.txt

mv *_out_*txt OUT
mv *_err_*txt ERROR

source scripts/multiqc_slurm.sh $2
## Alignment of each fastq file starts here



# This script will print some usage statistics to the
# end of file: STAR_out
# Use that to improve your resource request estimate
# on later jobs.
##used_slurm_resources.bash