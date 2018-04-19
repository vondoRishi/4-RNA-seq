#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J cuffdiff
#SBATCH --constraint="snb|hsw"
#SBATCH -o OUT/cuffdiff_out_%j.txt
#SBATCH -e ERROR/cuffdiff_err_%j.txt
#SBATCH -p serial
#SBATCH -n 1
#SBATCH -t 03:20:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-type=END

module load biokit 
rm -rf commands/cuffdiff_$1_$2_$3_commands.txt
  if [ ! -d cuffdiff_$1_$2_$3 ]
   then
        mkdir cuffdiff_$1_$2_$3
   fi

echo "cuffdiff -o cuffdiff_$1_$2_$3  -p 6 -u -L $2,$3  $WRKDIR/DONOTREMOVE/Mouse_genome/Mus_musculus.GRCm38.79.gtf \ " >> commands/cuffdiff_$1_$2_$3_commands.txt
	
for u_file in $4/*$1*$2*bam
do
  if [  -f $u_file ]
   then

  echo "$u_file,\\" >> commands/cuffdiff_$1_$2_$3_commands.txt
  
fi
done

  echo " \\" >> commands/cuffdiff_$1_$2_$3_commands.txt

for my_file in $4/*$1*$3*bam
do
  if [  -f $my_file ]
   then

  echo "$my_file,\\" >> commands/cuffdiff_$1_$2_$3_commands.txt
  
fi
done
# sbatch_commandlist -t 12:00:00 -mem 24000 -jobname cuffdiff_array -threads 8 -commands commands/cuffdiff_$1_$2_$3_commands.txt

# This script will print some usage statistics to the
# end of file: cuffdiff_out
# Use that to improve your resource request estimate
# on later jobs.
used_slurm_resources.bash
