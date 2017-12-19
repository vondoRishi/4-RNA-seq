#!/bin/bash -l
# created: Aug 22, 2017 1:55 PM
# author: dasroy
#SBATCH -J cat_gz
#SBATCH --constraint="snb|hsw"
#SBATCH -o OUT/cat_gz_out_%j.txt
#SBATCH -e ERROR/cat_gz_err_%j.txt
#SBATCH -p serial
#SBATCH -n 1
#SBATCH -t 01:20:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-type=END

# commands to manage the batch script
#   submission command
#     sbatch [script-file]
#   status command
#     squeue -u dasroy
#   termination command
#     scancel [jobid]

# For more information
#   man sbatch
#   more examples in Taito guide in
#   http://research.csc.fi/taito-user-guide

# example run commands
sbatch_commandlist -jobname cat -commands commands/cat_gz.txt

# This script will print some usage statistics to the
# end of file: cat_gz_out
# Use that to improve your resource request estimate
# on later jobs.
used_slurm_resources.bash
