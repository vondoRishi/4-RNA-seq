#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J cat_gz
#SBATCH -o OUT/cat_gz_out_%j.txt
#SBATCH -e ERROR/cat_gz_err_%j.txt
#SBATCH -p large
#SBATCH -n 2
#SBATCH -t 01:20:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-type=END

source scripts/command_utility.sh
num_cmnds=$( cmnds_in_file )

if test -f "$1" ; then
        if test ! -d $2 ; then
                mkdir $2
        else
                echo "Output directory exists!!"
                exit 1 
        fi

	rm -f $2/cat_summary.txt
        while IFS= read -r line
        do
          echo "cat */*$line*fastq.gz > $2/$line.fastq.gz" >> commands/$num_cmnds"_cat.gz".txt
          ls */*$line*fastq.gz >> $2/cat_summary.txt 
        done < "$1"
        
        sbatch_commandlist -jobname cat -commands commands/$num_cmnds"_cat.gz".txt
else 
    echo "sample names is missing"
        # sbatch_commandlist -jobname cat -commands commands/cat_gz.txt
fi

mv *_out_*txt OUT
mv *_err_*txt ERROR

