#!/bin/bash

source scripts/command_utility.sh
## Uncompressing
my_file="$3"
echo "processing $my_file"

        filename="${my_file##*/}"
	extension="${filename##*.}"
	filename="${filename%.*}"

echo "zcat $my_file > $1/$filename"
zcat $my_file > $1/$filename

## Sortmerna
if [[ ! -f $sortMeRNA_ref && ! -d $sortMeRNA_ref ]]; then
        echoerr "ERROR:  $sortMeRNA_ref do not exist"
	if [[ "$1" != "$test_str" ]]; then
	        exit 1
	fi
fi

## Sortmerna
basename="${filename%.*}"

ref_msg=$( sortmerna_refString )
ref_str=${ref_msg##*=}

echo "sortmerna  --ref  $ref_str --reads $1/$filename \
          --aligned $2/rRna_$basename --other $2/non_rRna_$basename \
          --sam --SQ --log -v  --fastx  -a 8 " 
	  
sortmerna  --ref  $ref_str --reads $1/$filename \
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


