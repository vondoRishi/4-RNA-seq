#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J index_sortmerna
#SBATCH -o OUT/index_sortmerna_out_%j.txt
#SBATCH -e ERROR/index_sortmerna_err_%j.txt
#SBATCH -p large
#SBATCH -n 2
#SBATCH -t 03:20:00
#SBATCH --mem-per-cpu=16000
#SBATCH --mail-type=END

source scripts/command_utility.sh
module load qiime2

if [[ ! -f $sortMeRNA_ref && ! -d $sortMeRNA_ref ]]; then
        echoerr "ERROR:  $sortMeRNA_ref do not exist"
	if [[ "$1" != "$test_str" ]]; then
	        exit 1
	fi
fi

ref_msg=$( sortmerna_refString )

ref_str=${ref_msg##*=}
echo "reference $ref_str"

if [[  ${#ref_str} -lt 5 ]]; then
	echoerr "ERROR: No reference fasta found"
	if [[ "$1" != "$test_str" ]]; then
	        exit 1
	fi

fi

indexing_required=${ref_msg%=*}
echo "msg $indexing_required"
if [[ ${#indexing_required} -gt 0 ]]; then 
	echo "indexdb_rna --ref $ref_str"
	indexdb_rna --ref $ref_str
fi

