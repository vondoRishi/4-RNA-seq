This folder should contain executable scripts.

### Tips  

Example of helpful commands  

#### Archiving whole folder
```bash
tar -pczf 4-RNA-seq-master.tar.gz 4-RNA-seq-master/ --exclude="4-RNA-seq-master/star-genome_ann_Indices"
```  

#### Generating summary report  
helpful to host in a ftp server
```bash
tree -C -I "*.md|*.tab|*.out|*.bam|*A0*|star-genome*" -L 2 -t -H . > summary.html
```


