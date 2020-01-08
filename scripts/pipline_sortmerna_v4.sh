# connect to the puhti.csc.fi
ssh lanqiang@puhti.csc.fi


####set up the enviroment and some necessary software

# Execute this command only once in your account
## in the new puhti supercomputer there is not preinstalled biopython-env. so I need to creat the env with conda ourself.

#change the envs_dirs into the desired location
conda config --append envs_dirs /projappl/project_2002302/my_env/python3_env
#creat the evn of python3-env
conda create -n python3-env python=3

conda activate python3-env
pip install biopython


pip install --upgrade pip
pip install multiqc
pip install numpy --upgrade


## Check the installation and manual
multiqc -h

export PROJAPPL=/projappl/project_2002302

##sortmerna in the qiime2 is too old and sometime introduce some erro in output fastq files. tried to install it myself
cd /projappl/project_2002302/
wget https://github.com/biocore/sortmerna/releases/download/v4.0.0/sortmerna-4.0.0-linux.sh

bash sortmerna-4.0.0-Linux.sh  # the sortnerna installed in the folder /projappl/project_2002302/sortmerna-4.0.0-Linux/bin

#set PATH ## you need run this commond in your working directory.
export PATH=/projappl/project_2002302/sortmerna-4.0.0-Linux/bin:$PATH

##if sortmerna-4.0.0 does not work. remove from the PATH
PATH=$(echo "$PATH" | sed -e 's/:\/projappl\/project_2002302\/sortmerna-4.0.0-Linux\/bin$//')


####optional tools to validate the  fastq file:

git clone https://github.com/statgen/libStatGen.git  ##package necessary for compiling the fastQValidator

cd path_to/libStatGen
make clean
git pull
make all

###start download then complie fastqValidator
cd ..  ##get out of the libstatgen folder

#download the fastQValidator
git clone git://github.com/statgen/fastQValidator.git

cd path_to/fastQValidator
make clean
git pull
make all

###ready to use in a dirty way. 
##How to add the shotcut to the bin??

/projappl/project_2002302/fastQValidator/bin/fastQValidator --file path/to/your/file.fastq

####### start the real work

# go to the working directory
cd /scratch/project_2002302/WRKDIR/Merged_1_2_sortmeRna_v4

mkdir RawReads

cd RawReads
##get the RawReads into the folder. with 2 round sequencing 


##rawdata fastqc and multiqc
sbatch --mail-user qiang.lan@helsinki.fi scripts/fastqc.sh RawReads


##trimming the adaptor 
## changed the paprameters
sbatch --mail-user qiang.lan@helsinki.fi scripts/trimmo.sh Merged_RawReads trimmed_first

#QA for the trimmed data

sbatch --mail-user qiang.lan@helsinki.fi scripts/fastqc.sh trimmed_first #590066  & 590067_1


# filter rRNA. fastq.gz file in RawReads folder, and processed file will stored in sortMeRna
######sortMeRna sometimes bring some mistake to the fastqfile for trimming treatemtn. do the trimming first.
sbatch --mail-user qiang.lan@helsinki.fi scripts/sortmerna.sh trimmed_first sortMeRna_2  ##583841  / 583870_1 for 1_2_Merged

#first run #121 gets wrong. second run 115 gets some wrong with output  3rd. #584514-->584415

#### try to us the sortmerna v4 for doing the job in a single task
###sbatch --mail-user qiang.lan@helsinki.fi scripts/sortmerna_v4_single_tasks.sh trimmed_first sortmerna_v4 ##590179 


##alternative we can run the sortmerna ve in the array . use sortmerna_v4_array.sh.
# compile the input folder to the file list
ls trimmed_first/*.{fastq,fq,fastq.gz,fq.gz} >namelist

sbatch --mail-user qiang.lan@helsinki.fi scripts/sortmerna_v4_array.sh sortmerna_v4_array  #590299 for 1-5 593123 for 6-25

##rawdata fastqc and multiqc

sbatch --mail-user qiang.lan@helsinki.fi scripts/fastqc.sh sortmerna_v4_array  #591557 591558

#compress the rRNA filterd fastq file in sortMeRna folder
sbatch --mail-user qiang.lan@helsinki.fi scripts/compress_fastq.sh sortmerna_v4  #590304  for test_only folder
sbatch --mail-user qiang.lan@helsinki.fi scripts/compress_fastq.sh sortmerna_v4_array #590310  ##failed. 

sbatch --mail-user qiang.lan@helsinki.fi scripts/compress_fastq.sh sortmerna_v4_array
_________________
#####some useful command
watch 'squeue -l -u $USER'

sinfo -Nel |grep large |grep idle >serinfor_test.txt  ##find the infomation of service based on the partian
 
seff <jobId> # check the efficiency of the bash process
________________

current pwd /scratch/project_2002302/WRKDIR/1st_round/test_only

##download the genome gtf and fasta file into you folder
$HOME/mouse_genome_release_98/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz
$HOME/mouse_genome_release_98/Mus_musculus.GRCm38.98.gtf.gz

gunzip $HOME/mouse_genome_release_98/*.gz

#add the path to the 4-rna.config  file

sbatch --mail-user qiang.lan@helsinki.fi scripts/star.sh sortmerna_v4_array star_alignment   #592757 , 592759->indexing #592818_1 for alignment
                                                                                        
### index the bam file with samtools
sbatch --mail-user qiang.lan@helsinki.fi scripts/samtools_index.sh star_alignment ## 

#read_counts
sbatch --mail-user qiang.lan@helsinki.fi scripts/star_htseq-count.sh star_alignment star_count ##592957  592993_1 



##final report, by command option the configuration has been assigned.
sbatch --mail-user qiang.lan@helsinki.fi scripts/multiqc_slurm.sh

## make summary of the directry structure tree
tree -C -I "*.md|*.tab|*.out|*.bam|*A0*|star-genome*" -L 2 -t -H . > summary.html

tree -f >summary.txt

###compress the 1st_round samples

##Archiving whole folder
tar -pczf 4-RNA-seq-QL_1st_round.tar.gz 1st_round/ --exclude="1st_round/star-genome_ann_Indices"



==========

##Merge the sample form 2 rounds

sbatch -D $PWD --mail-user qiang.lan@helsinki.fi scripts/cat.gz.sh sample_name.txt Merged_RawReads




#additional

zcat /scratch/project_2002302/WRKDIR/2nd_round/RawReads/A006_121_CTGAAGCT_GCCTCTAT_run20191212N_S6_R1_001.fastq.gz >>

/projappl/project_2002302/fastQValidator/bin/fastQValidator --file /scratch/project_2002302/WRKDIR/1_2_Merged/sortMeRna_2/*.fastq

