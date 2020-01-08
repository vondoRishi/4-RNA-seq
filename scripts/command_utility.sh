#!/bin/bash

source 4-rna-seq.config
cmnds_in_file () {
	ls commands  | wc -l
}
num_cmnds=$( cmnds_in_file )
# echo  "$num_cmnds"_cmnds lines in it.
