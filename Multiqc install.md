If you use biopython-env module, you can easily install multiqc for your own use. Try commands:

  > module load biopython-env  
  > pip install --upgrade pip  
  > pip install multiqc  
  
if there are arrors related to "numpy" then try  
  > pip install numpy --upgrade

After that you can start the program with command:   
  > multiqc

Next time when you log in, you can start multiqc with commands:   
  > module load biopython-env   
  > multiqc   
