This guideline is for puhti.csc.fi which does not look very stable now. Following instructions may need to update carefully again additionally with multiqc scripts

> export PROJAPPL=/projappl/<project_id>/<user>/ # Any path which is advised to use by system administrator  
> module load bioconda  
> conda create --name multiqc  
> source activate multiqc  
> conda install -c bioconda -c conda-forge multiqc     
  
After that you can start the program with command:   
  > multiqc  

Next time when you log in, you can start multiqc with commands:   
> export PROJAPPL=/projappl/<project_id>/<user>/ # Any path which is advised to use by system administrator  
> module load bioconda  
> source activate multiqc  
> multiqc   
