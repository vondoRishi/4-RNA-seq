#! /bin/bash

#source 4-rna-seq.config
source scripts/command_utility.sh 

validate_param

slurm_arg="--parsable -A $account -D $PWD --mail-user $email"
# QC of rawdata 
## fastqc
jid1=$(sbatch  $slurm_arg scripts/fastqc.sh rawReads)

## AfterQC
jid2=$(sbatch  --dependency=afterok:$jid1  $slurm_arg scripts/afterqc_batch.sh rawReads )

## Trimmomatic
jid3=$(sbatch  --dependency=afterok:$jid2  $slurm_arg scripts/trimmo.sh good trimmed_reads  )

## Sortmerna
### Index
jid_ind=$(sbatch    $slurm_arg scripts/sortMeRNA_indexdb.sh )

jid4=$(sbatch  --dependency=afterok:$jid_ind:$jid3  $slurm_arg scripts/sortmerna.sh trimmed_reads sortMeRna )

## Check the quality of reads after QC  
jid6=$(sbatch  --dependency=afterok:$jid4  $slurm_arg scripts/fastqc.sh sortMeRna)

# Quantification
## Salmon
jid7=$(sbatch  --dependency=afterok:$jid6  $slurm_arg scripts/salmon.sh sortMeRna salmon_index salmon_quant )


#Final report
jid8=$(sbatch  --dependency=afterok:$jid7  $slurm_arg -J final_report scripts/multiqc_slurm.sh )
