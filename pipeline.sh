#! /bin/bash

source 4-rna-seq.config

# QC of rawdata 
## fastqc
jid1=$(sbatch --parsable -A $account -D $PWD --mail-user $email scripts/fastqc.sh rawReads)

## AfterQC
jid2=$(sbatch --parsable  --dependency=afterok:$jid1 -A $account -D $PWD --mail-user $email scripts/afterqc_batch.sh rawReads )

## Trimmomatic
jid3=$(sbatch --parsable  --dependency=afterok:$jid2 -A $account -D $PWD --mail-user $email scripts/trimmo.sh good trimmed_reads  )

## Sortmerna
jid4=$(sbatch --parsable  --dependency=afterok:$jid3 -A $account -D $PWD --mail-user $email scripts/sortmerna.sh trimmed_reads sortMeRna )

jid5=$(sbatch --parsable  --dependency=afterok:$jid4 -A $account -D $PWD --mail-user $email scripts/compress_fastq.sh sortMeRna)

jid6=$(sbatch --parsable  --dependency=afterok:$jid5 -A $account -D $PWD --mail-user $email scripts/fastqc.sh sortMeRna)

## Salmon
jid7=$(sbatch --parsable  --dependency=afterok:$jid6 -A $account -D $PWD --mail-user $email scripts/salmon.sh sortMeRna salmon_index salmon_quant )


#Final report
jid8=$(sbatch --parsable  --dependency=afterok:$jid7 -A $account -D $PWD --mail-user $email scripts/multiqc_slurm.sh )
