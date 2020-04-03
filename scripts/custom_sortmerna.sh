#!/bin/bash

source 4-rna-seq.config

## Uncompressing
my_file="$3"
echo "processing $my_file"

        filename="${my_file##*/}"
	extension="${filename##*.}"
	filename="${filename%.*}"

echo "zcat $my_file > $1/$filename"
zcat $my_file > $1/$filename

## Sortmerna
basename="${filename%.*}"
idx_file=$sortMeRNA_ref
idx_name="${idx_file%.*}"
index_file="$idx_name.idx"

echo "sortmerna  --ref  $sortMeRNA_ref,$index_file --reads $1/$filename \
          --aligned $2/rRna_$basename --other $2/non_rRna_$basename \
          --sam --SQ --log -v  --fastx  -a 8 " 
	  
sortmerna  --ref  $sortMeRNA_ref,$index_file --reads $1/$filename \
          --aligned $2/rRna_$basename --other $2/non_rRna_$basename \
          --sam --SQ --log -v  --fastx  -a 8  

## Removing unnecessary files
echo "rm -f $1/$filename"
rm -f $1/$filename
rm -f $2/rRna_$basename.fq

## Compressing files
    #Check for blank lines in sortMeRna files. Star Aligner will not take any lines after a blank line as input. 
    #https://www.biostars.org/p/302365/#315729
    num_blank=$(grep -E --line-number --with-filename "^$" $2/non_rRna_$basename.fq | wc -l)
        if [ $num_blank -gt 0 ]
        then
	        #if blank lines exist, remove them and add to log file
	        grep -E --line-number --with-filename '^$' $2/non_rRna_$basename.fq >> ERROR/blank_lines_check.txt
	        sed -i '/^$/d' $2/non_rRna_$basename.fq
        fi
  echo "gzip  $2/non_rRna_$basename.fq "
  gzip $2/non_rRna_$basename.fq
