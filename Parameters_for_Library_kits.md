### **Unstranded:**
Information regarding the strand is not conserved (it is lost during the amplification of the mRNA fragments).  
**Kits:** TruSeq RNA Sample Prep kit  
**Parameters:**  
* TopHat / Cufflinks / Cuffdiff: library-type fr-unstranded  
*  HTSeq: stranded -- no  
### **Directional, first strand:**
The second read (read 2) is from the original RNA strand/template, first read (read 1) is from the opposite strand. The information of the strand is preserved as the original RNA strand is degradated due to the dUTPs incorporated in the second synthesis step.  
**Kits:**  
* All dUTP methods, NSR, NNSR  
* TruSeq Stranded Total RNA Sample Prep Kit  
* TruSeq Stranded mRNA Sample Prep Kit  
* NEB Ultra Directional RNA Library Prep Kit   
* Agilent SureSelect Strand-Specific  
  
**Parameters:**  
* TopHat / Cufflinks / Cuffdiff: library-type fr-firststrand  
* HTSeq: stranded -- reverse  
### **Directional, second strand:**
The first read (read 1) is from the original RNA strand/template, second read (read 2) is from the opposite strand. The directionality is preserved, as different adapters are ligated to different ends of the fragment.   
**Kits:**  
* Directional Illumina (Ligation), Standard SOLiD  
* ScriptSeq v2 RNA-Seq Library Preparation Kit  
* SMARTer Stranded Total RNA   
* Encore Complete RNA-Seq Library Systems  
* Ovation® SoLo RNA-Seq Systems \[ checked through IGV tools ]
  
**Parameters:**  
* TopHat / Cufflinks / Cuffdiff: library-type fr-secondstrand  
*  HTSeq: stranded -- yes  
Source : [Directional RNA-seq data -which parameters to choose?](http://chipster.csc.fi/manual/library-type-summary.html)
