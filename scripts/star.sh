#!/bin/bash -l
# author: dasroy
#SBATCH -J Star
#SBATCH -o OUT/singleStar_out_%j.txt
#SBATCH -e ERROR/singleStar_err_%j.txt
#SBATCH -p large
#SBATCH -n 2
#SBATCH -t 12:00:00
#SBATCH --mem=4000
#SBATCH --mail-type=END

source scripts/command_utility.sh

module load gcc/9.1.0 star/2.7.2
echo "STAR" >> version.txt
STAR --version  >> version.txt

## Starting Indexing the genome
if [ ! -d star-genome_ann_Indices ]; then
	
	mkdir star-genome_ann_Indices
	overhang=$(( maxReadLength - 1 ))

	echo "STAR --runMode genomeGenerate --genomeDir star-genome_ann_Indices \
		--genomeFastaFiles $genome_file --sjdbGTFfile  $gene_annotation \
		--runThreadN 6 --sjdbOverhang $overhang" >> commands/$num_cmnds"_star-genome_annotated".txt 

	array_msg=$( sbatch_commandlist -t 12:00:00 -mem 64000 -jobname star-indexing \
	-threads 6  -commands commands/$num_cmnds"_star-genome_annotated".txt )

	mv *_out_*txt OUT
	mv *_err_*txt ERROR

	check_array_jobStatus "$array_msg"

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

array_msg=$( sbatch_commandlist -t 12:00:00 -mem 48000 -jobname STAR_alignment_array \
-threads 4 -commands commands/$num_cmnds"_STAR_align_"$1_commands.txt )

mv *_out_*txt OUT
mv *_err_*txt ERROR

check_array_jobStatus "$array_msg"

source scripts/multiqc_slurm.sh $2
## Alignment of each fastq file starts here



