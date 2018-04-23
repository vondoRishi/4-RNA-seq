#!/bin/bash -l
# author: dasroy
#SBATCH -J singleStar
#SBATCH --constraint="snb|hsw"
#SBATCH -o OUT/singleStar_out_%j.txt
#SBATCH -e ERROR/singleStar_err_%j.txt
#SBATCH -p serial
#SBATCH -n 1
#SBATCH -t 12:00:00
#SBATCH --mem=4000
#SBATCH --mail-type=END

source scripts/command_utility.sh
num_cmnds=$( cmnds_in_file )

mkdir star-genome_ann_Indices

echo "STAR --runMode genomeGenerate --genomeDir star-genome_ann_Indices --genomeFastaFiles $WRKDIR/DONOTREMOVE/Mouse_genome/Mus_musculus_GRCm38.fa --sjdbGTFfile $WRKDIR/DONOTREMOVE/Mouse_genome/Mus_musculus.GRCm38.79.gtf  --runThreadN 6 --sjdbOverhang 83" >>commands/$num_cmnds"_star-genome_annotated".txt 

## sjdbOverhang should be (Max_Read_length - 1)
sbatch_commandlist -t 12:00:00 -mem 64000 -jobname star-genome -threads 6  -commands commands/$num_cmnds"_star-genome_annotated".txt 

mv *_out_*txt OUT
mv *_err_*txt ERROR

source scripts/star_aligner_annotated.sh $1 $2
source scripts/multiqc_slurm.sh $2

used_slurm_resources.bash
