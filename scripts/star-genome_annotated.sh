#!/bin/bash -l
# author: dasroy
#SBATCH -J singleStar
#SBATCH --constraint="snb|hsw"
#SBATCH -o OUT/singleStar.out
#SBATCH -e ERROR/singleStar.err
#SBATCH -p serial
#SBATCH -n 6
#SBATCH -t 12:00:00
#SBATCH --mem=64000
#SBATCH --mail-type=END

mkdir star-genome_ann_Indices
STAR --runMode genomeGenerate --genomeDir star-genome_ann_Indices --genomeFastaFiles $WRKDIR/DONOTREMOVE/Mouse_genome/Mus_musculus_GRCm38.fa --sjdbGTFfile $WRKDIR/DONOTREMOVE/Mouse_genome/Mus_musculus.GRCm38.79.gtf  --runThreadN 6 --sjdbOverhang 83

## sjdbOverhang should be (Max_Read_length - 1)

used_slurm_resources.bash
