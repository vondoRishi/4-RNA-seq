## Puhti
 **csc-workspaces set project** not working now which means environment variables $SCRATCH and $PROJAPPL are not available.  

We need to download AfterQC and unzip it to /scratch/**project_dir** directory. Replace "project_dir" with proper path, for [example](https://docs.csc.fi/#computing/disk/#projappl-directory).  
 It can be done by executting following commands  
   1. > wget -P /scratch/**project_dir** https://github.com/OpenGene/AfterQC/archive/master.zip
   2. > unzip -d /scratch/**project_dir** /scratch/**project_dir**/master.zip  

## Taito
We need to download AfterQC and unzip it to $USERAPPL directory. It can be done by executting following commands  
   1. > wget -P $USERAPPL https://github.com/OpenGene/AfterQC/archive/master.zip
   2. > unzip -d $USERAPPL $USERAPPL/master.zip
