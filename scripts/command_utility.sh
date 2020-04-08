#!/bin/bash

cmnds_in_file () {
	ls commands  | wc -l
}
num_cmnds=$( cmnds_in_file )
# echo  "$num_cmnds"_cmnds lines in it.

echoerr() { echo "$@" 1>&2; }

check_array_jobs () {

jobid=$(tail -1 commandlist.output | awk '{print $3}' )

##echo $jobid

non_completed=$(( $(sacct -j $jobid | grep -v COMPLETED | wc -l) - 2 ))

if [[ $non_completed -gt 0 ]]; then
  echoerr "Some jobs failed or are still running"
  failed=$( sacct -j $jobid | grep -v COMPLETED )
  echoerr $failed
  exit 1
else
  echo "All done!"
fi

}

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
source 4-rna-seq.config
