#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J ida
#SBATCH -o OUT/ida_out_%j.txt
#SBATCH -e ERROR/ida_err_%j.txt
#SBATCH -p small
#SBATCH -n 1
#SBATCH -t 02:50:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-type=END

for my_file in $1/*.{fastq,fastq.gz,fq,fq.gz}
do
if [  -f $my_file ]
then
        filename="${my_file##*/}"
	ida upload /Rat/SingleFastq/$filename $my_file
fi
done

mv *_out_*txt OUT
mv *_err_*txt ERROR
