#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J cuffdiff
#SBATCH -o OUT/cuffdiff_out_%j.txt
#SBATCH -e ERROR/cuffdiff_err_%j.txt
#SBATCH -p large
#SBATCH -n 2
#SBATCH -t 03:20:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-type=END

source scripts/command_utility.sh
num_cmnds=$( cmnds_in_file )

module load biokit 
  if [ ! -d cuffdiff_$1_$2_$3 ]
   then
        mkdir cuffdiff_$1_$2_$3
   fi

echo "cuffdiff -o cuffdiff_$1_$2_$3  -p 6 -u -L $2,$3  $WRKDIR/DONOTREMOVE/Mouse_genome/Mus_musculus.GRCm38.79.gtf \ " >> commands/$num_cmnds"_cuffdiff_"$1_$2_$3.txt
	
for u_file in $4/*$1*$2*bam
do
  if [  -f $u_file ]
   then

  echo "$u_file,\\" >> commands/$num_cmnds"_cuffdiff_"$1_$2_$3.txt
  
fi
done

  echo " \\" >> commands/$num_cmnds"_cuffdiff_"$1_$2_$3.txt

for my_file in $4/*$1*$3*bam
do
  if [  -f $my_file ]
   then

  echo "$my_file,\\" >> commands/$num_cmnds"_cuffdiff_"$1_$2_$3.txt
  
fi
done
# sbatch_commandlist -t 12:00:00 -mem 24000 -jobname cuffdiff_array -threads 8 -commands commands/$num_cmnds"_cuffdiff_"$1_$2_$3.txt

