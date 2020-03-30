#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J tophat2
#SBATCH -o OUT/tophat2_out_%j.txt
#SBATCH -e ERROR/tophat2_err_%j.txt
#SBATCH -p small
#SBATCH -n 1
#SBATCH -t 12:20:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-type=END

source scripts/command_utility.sh
num_cmnds=$( cmnds_in_file )

module load biokit

if [ ! -d "$2" ]
then
        mkdir $2
fi

for my_file in $1/*.{fastq*,fq.gz}
do
if [  -f "$my_file" ]
then
	filename="${my_file##*/}"
        extension="${filename##*.}"
        filename="${filename%.*}"  

echo "tophat2 --library-type fr-firststrand -p 4 -o $2/$filename $WRKDIR/DONOTREMOVE/Mouse_genome/Mus_musculus_GRCm38  $my_file " >> commands/$num_cmnds"_tophat2_"$1.txt
fi
done
sbatch_commandlist -t 12:00:00 -mem 24000 -jobname tophat2_array -threads 4 -commands  commands/$num_cmnds"_tophat2_"$1.txt

mv *_out_*txt OUT
mv *_err_*txt ERROR

source scripts/multiqc_slurm.sh $2
