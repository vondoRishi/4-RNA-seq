#!/bin/bash

cmnds_in_file () {
	ls commands  | wc -l
}
num_cmnds=$( cmnds_in_file )
# echo  "$num_cmnds"_cmnds lines in it.

echoerr() { echo "$@" 1>&2; }


check_array_jobStatus () {
test_str="test"
echo "@@@@ array_job_message"
echo $1
echo "@@@@ array_job_message"

echo $2
#echo "***"

finished=${1##*:}
#echo $finished

jobid=${finished% *}
echo $jobid

non_completed=$(( $(sacct -j $jobid | grep -v COMPLETED | wc -l) - 2 ))

if [[ $non_completed -gt 0 ]]; then
  echoerr "Some jobs failed or are still running"
  failed=$( sacct -j $jobid | grep -v COMPLETED )
  echoerr "$failed"
  if [[	"$2" != "$test_str" ]]; then
  	echo "array job failed, exiting ***"
	exit 1
  fi
else
  echo "All done!"
fi

}

sortmerna_refString () {
if [ ! -d $sortMeRNA_ref ]; then
	sortMeRNA_ref=$(dirname $sortMeRNA_ref)
	# echo "dirname $sortMeRNA_ref"
fi

index_ref=""
indexing_done=""
for my_file in $sortMeRNA_ref/*.fasta
do
   if [  -f $my_file ] ; then
	index_file="${my_file%.*}.idx"

	   if [[ ${#index_ref} -gt 0 ]] ; then
	      index_ref+=":"
	   fi
	   index_ref+="$my_file,$index_file"
	if [[ ! -f "$index_file.stats" ]]; then
	   indexing_done="indexing required"
	fi
   fi
done

echo "$indexing_done=$index_ref"
}

validate_param(){
   if [[ ${#email} -lt 1 ]] ; then
	      echo "Please enter valid email $email" >/dev/stderr
	      exit 1
   fi

   if [[ ${#account} -lt 1 ]] ; then
	      echo "Please enter valid account ID  $account" >/dev/stderr
	      exit 1
   fi
}

source 4-rna-seq.config
