# 4-RNA-seq
A [slurm](https://slurm.schedmd.com/) based schema for RNA-seq analysis to execute on linux clusters.  A **Pipeline:4-RNA-seq and a minimal RNA-seq cook book** to explain each step is freely available [here](https://vondorishi.github.io/4-RNA-seq/). This book was based on old Taito server. For practical use read below instructions.   

The purpose of this project to develop a easily customizable commandline based schema "for RNAseq" analysis. Additionally it has basic linux scripts for file manipulation which is bottle neck for developing new command line pipeline.

## Major update

* SortmeRNA:
	+ Now possible to give multiple fasta files as reference.
	+ Tuned for disk utilization and no need for a separate command to compress fastq files. 
* pipeline.sh : single command to finish the whole pipeline.
* errors handling : halt and send right job status by email after error in any of the tasks from sbatch_commandlist.
* version.txt : tracks the versions of the used software for fututre reference.

## Installation
4-RNA-seq is required to download every new project.  
__Download__   
For each experiment 4-RNA-seq pipeline needs to be downloaded separately. Let us download it to a directory named  "myProjectDir" with following commands

```bash
git clone https://github.com/vondoRishi/4-RNA-seq myProjectDir
```
From now on __myProjectDir__ is the project space

__Prepare the workspace__   
Make a directory "rawreads" inside  "myProjectDir" and copy fastq(.gz) files there.

```bash
mkdir myProjectDir/rawReads
cp sourceDir/*fastq.gz myProjectDir/rawReads
```
# RNA-seq pipeline

This pipeline and workflow is optimized for [Puhti](https://docs.csc.fi/#computing/overview/) server. The old pipeline for [Taito.csc server](https://research.csc.fi/taito-batch-jobs) is moved at "Taito" branch due to decommisioning of the old server.  
#### Please read the server documentation before start using. It may need to customized according to that.
The **objective** of this documentation is to make execution faster and reproducible as much as possible. The project folder ( should be in /scratch/\<project\> path and in this example "myProjectDir" ) should contain these folders before starting
* scripts : contains all scripts to run in taito server
* OUT : contains  output files from all scripts 
* ERROR : contains error files from all scripts 
* commands : contains actual commands { will be required in future to find the project specific parameters }
* rawReads : should contain sequencing reads generated by the sequencing machine. Folder name could be anything.

![The schema](https://github.com/vondoRishi/4-RNA-seq/blob/master/4-rna-seq.jpg)  

**Additional info** :  Library type, sequencing platform
Input: Reference Genome (DNA sequences) fasta and annotation file (GTF)
Run “ls -lrth” after every step to find the last modified file

## Dependency   
Need to install afterqc by the users of puhti.csc.fi.
 * [AfterQC](https://github.com/OpenGene/AfterQC)  { installation [guide](https://github.com/vondoRishi/4-RNA-seq/blob/master/AfterQC%20install.md) .}

# Execution
Before execution please define the project variables inside **4-rna-seq.config** file.  
These values will be used by different scripts of this pipeline.  

```bash
cd myProjectDir
```  

**Before execution please confirm that there are enough space**

## Quickest way

If the varibles are defined correctly then with the single command QC and transcript/gene quantification can be performed.

```bash
bash pipeline.sh
```  
This will execute FastQC, AfterQC, Sortmerna, Salmon and MultiQC. After Completion of each step it will send an email.

Do not forget to check any error/failure message from any of the programs 

```bash
grep -rnwi ERROR OUT -e 'error\|fail\|Disk.*'
```  

# Manual execution step by step

## QC and Filtering
1.	Start QC ( quality checking) with [Fastqc](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)  and [Multiqc](http://multiqc.info/). The scripts/fastqc.sh executes first Fastqc and then Multiqc internally.

Input : directory rawReads with fastq or fastq.gz files  
Execution: Replace \<project> and <email_id>.
```bash
sbatch -A <project> -D $PWD --mail-user <email_id> scripts/fastqc.sh rawReads  # Don't use "rawReads/" 
```
Output : directory rawReads/rawReads.html and other files  
```bash
ls -lrth rawReads/
```

2.	Filter/trimminging with  
     a) [AfterQC](https://github.com/OpenGene/AfterQC) (Define the "AfterQC" variable in 4-rna-seq.config before using)  
Input : directory rawReads with fastq or fastq.gz files  
Execution :
```bash
sbatch -A <project> -D $PWD --mail-user <email_id> scripts/afterqc_batch.sh rawReads  
```   

Output : directory good, bad and QC  

b) ALERT for *"single end reads"* users!! AfterQC can not trim adapters from [single end reads](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-017-1469-3). Hence use Trimmomatic to cut adapters \[ check for trimming parameters ] \[ Tips for filename ]  
		Input : directory good with fastq or fastq.gz files   
Execution:  
```bash
sbatch -A <project> -D $PWD --mail-user <email_id> scripts/trimmo.sh good trimmed_reads  
```  
Output : directory trimmed_reads  

_{ Run step 1 review effect of trimming }_

3. [Sortmerna.sh](http://bioinfo.lifl.fr/RNA/sortmerna/) \[ We can also execute this at the very beginning (optional) ]  
	Sometimes ribosomal or any other unwanted RNAs may present in the library. Sortmerna could be used to filterout them.  
	Confirm the parameters in file 4-rna-seq.config  
	+ "sortMeRNA_ref" path to a folder to reference rRNA fasta files.
	
	__First index the reference fasta file__  
	If the indexing is available then the program will do nothing.  
	Input: *sortMeRNA_ref* variable in 4-rna-seq.config    
	Execution:  
	```bash
	sbatch -A <project> -D $PWD --mail-user <email_id> scripts/sortMeRNA_indexdb.sh   
	```  
	
	__Now filter out__  
	Input: good   
	Execution:  
	```bash
	sbatch -A <project> -D $PWD --mail-user <email_id> scripts/sortmerna.sh good sortMeRna   
	```  
	Output: sortMeRna, the folder contains many different types of file. Fastq/fq files starting with non_Rna will be used in downstream analysis. Files with .log will be used by multiqc to summarize. The "rRna" fastq/fq and ".sam" files are removed by default from __sortMeRna__ before next step. To retailn these files comment out "rm -rf $2/rRna_*{fastq,fq}"
	
	
	__Finally summarize the presence of rRNA.__  
	Execution: 
	```bash
	sbatch -A <project> -D $PWD --mail-user <email_id> scripts/fastqc.sh sortMeRna  
	```  
	Output: sortMeRna  

	

  
 ## Counting  
* __[Salmon](https://salmon.readthedocs.io/en/latest/)__  
	Confirm the parameters in file 4-rna-seq.config  
	+ "transcripts" path to reference transcripts  
	+ "gene_annotation" path to gtf file  

  Input: sortMeRna (any directory containing fastq files)
  Execution: 
  ```bash
  sbatch -A <project> -D $PWD --mail-user <email_id> scripts/salmon.sh sortMeRna salmon_index salmon_quant   
  ```  
  Output: salmon_index = transcriptome indices  
  	**salmon_quant** = provides a sub-directory with _quant.sf_ for each input samples
  

## Final report
Till now we have generated multiqc reports for every command or folder. Now to summarize all in one place execute.
Edit multiqc [configuration](https://github.com/vondoRishi/4-RNA-seq/blob/master/multiqc_config.yaml) file if requires 

```bash
sbatch -A <project> -D $PWD --mail-user <email_id> scripts/multiqc_slurm.sh
```

**salmon_quant** is the final out put folder. 

**Archieve the important folders**  

It is an example command only.

```bash
tar -czvf results_export.tar.gz *.html *.gtf* *.fa* salmon_quant/ 4-rna-seq.config version.txt
```


# EXTRA


 ## Alignment 
 Depending upon the library preparation kit the parameters of alignment software need to set. 
 Here are few examples of different popular [library kits](https://github.com/vondoRishi/4-RNA-seq/blob/master/Parameters_for_Library_kits.md). \[ please report any missing library type and parameters]    


To align to a reference genome 
* __[STAR](https://github.com/alexdobin/STAR):__  
	Confirm the parameters in file 4-rna-seq.config  
	+ "maxReadLength" to maximum read length  
	+ "genome_file" to path to reference genome  
	+ "gene_annotation" path to gtf file  

  Input: folder which contains the filtered reads; ex. __good__ or  __sortMeRna__   
  Execution: 
  ```bash
  sbatch -A <project> -D $PWD --mail-user <email_id> scripts/star.sh good star_alignment   
  ```  
  Output: star_alignment (contains bam files and quality report star_alignment.html)
  
## Counting  
* __[htseq-count](https://htseq.readthedocs.io/en/release_0.11.1/count.html)__  
\[ STAR can also give count values of htseq-count’s default parameter but htseq-count will be used separately\]   
	Confirm the parameters in file 4-rna-seq.config  
	+ "stranded" depending upon the library type  
	+ "gene_annotation" path to gtf file  

  Input: star_alignment   
  Execution: 
  ```bash
  sbatch -A <project> -D $PWD --mail-user <email_id> scripts/star_htseq-count.sh star_alignment star_count   
  ```  
  Output: count values at star_count/htseq_\*txt and quality report at star_count.html  
  
  
## Alignment read viewer
Need to sort (uncomment for tophat output bams) and index.

```bash
sbatch -A <project> -D $PWD --mail-user <email_id> scripts/samtools_index.sh bam_directory
```  
## Concatenating fastq files
There are, some times, multiple copies of same sample from multiple runs. It will be easier to concatenate all these multiple copies in single fastq.gz files before starting any workflow or 4-RNA-seq. Let us assume there are two samples control_1 and treated_1 and they have two copies from two separate runs, **run_1** and **run_2**. Therefore, in the project directory there should have two sub-directories 
* run_1
	+ control_1_run2019.fastq.gz  
	+ treated_1_run2019.fastq.gz  

* run_2
	+ control_1_run2020.fastq.gz  
	+ treated_1_run2020.fastq.gz  

Additionally another file, such as, sample_names.txt containing each sample names in a separate line. In this case the sample file should look like this
```
control_1  
treated_1  
```
Now we can use 
```bash
sbatch -A <project> -D $PWD --mail-user <email_id> scripts/cat.gz.sh sample_names.txt rawReads
```

**cat.gz.sh** will search any fastq.gz files matching with names given in **sample_names.txt** in ALL sub-directories and concatenate them. The output files can be found in **rawReads** directory.
  
## Compressing fastq files

```bash
sbatch -A <project> -D $PWD --mail-user <email_id> scripts/compress_fastq.sh old_data
```
## Cufflink 

```bash
sbatch scripts/cuffdiff_batch.sh Derm Ctrl Fgf20 star-genome_annotated 
```

