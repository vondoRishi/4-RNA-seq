#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J compress
#SBATCH -o OUT/compress_out_%j.txt
#SBATCH -e ERROR/compress_err_%j.txt
#SBATCH -p small
#SBATCH -n 1
#SBATCH -t 12:20:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-type=END

source scripts/command_utility.sh
num_cmnds=$( cmnds_in_file )

module load biokit

echo "Blank lines in sortMeRna files (STAR aligner input should NOT contain blank lines):" >> ERROR/blank_lines_check.txt
for my_file in $1/*.{fastq,fq}
do
if [  -f $my_file ]
then
    #Check for blank lines in sortMeRna files. Star Aligner will not take any lines after a blank line as input. 
    #https://www.biostars.org/p/302365/#315729
    num_blank=$(grep -E --line-number --with-filename "^$" $my_file | wc -l)
    if [ $num_blank -gt 0 ]
        then
	#if blank lines exist, remove them and add to log file
        grep -E --line-number --with-filename '^$' $my_file >> ERROR/blank_lines_check.txt
	sed -i '/^$/d' $my_file
        fi
    echo "gzip  $my_file " >> commands/$num_cmnds"_compress_"$1.txt
fi
done
sbatch_commandlist -t 12:00:00 -mem 4000 -jobname compress_array -threads 4 -commands  commands/$num_cmnds"_compress_"$1.txt

mv *_out_*txt OUT
mv *_err_*txt ERROR
