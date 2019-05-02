Tophat is not default choice of 4-RNA-seq pipeline. However ther are few example scripts which are not updated.

## Alignment  

* __Tophat2:__ run \[ change your parameters for stranded ]  
	Set path to reference genome in the script.
  Input: good  
  Execution: 
  ```bash
  sbatch -D $PWD --mail-user ur_email_at_domain scripts/tophat2.sh good tophat2_output   
  ```
  Output: tophat2_output (contains bam files and quality report tophat2_output.html)  
  
 ## Counting
  + Set path to GTF file inside the script.  
  Input: tophat2_output   
  Execution: 
  ```bash
  sbatch -D $PWD --mail-user ur_email_at_domain scripts/tophat2_htseq-count.sh tophat2_output
  ```  
  Output: tophat2_output/htseq_*txt
