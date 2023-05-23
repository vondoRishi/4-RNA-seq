## Puhti
 **csc-workspaces set project** not working now which means environment variables $SCRATCH and $PROJAPPL are not available.  

Install with [Tykky module](https://docs.csc.fi/computing/containers/tykky/)). Here is the required env.yml file will look

    channels:
      - bioconda
    dependencies:
      - python=2.7
      - afterqc


> conda-containerize new --prefix <install_dir> env.yml  

In 4-rna-seq.config file  
   
    AfterQC="/projappl/dasroy/afterqc/bin:$PATH"  

## Taito
We need to download AfterQC and unzip it to $USERAPPL directory. It can be done by executting following commands  
   1. > wget -P $USERAPPL https://github.com/OpenGene/AfterQC/archive/master.zip
   2. > unzip -d $USERAPPL $USERAPPL/master.zip
