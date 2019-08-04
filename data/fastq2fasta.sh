#/bin/bash 

less /Users/liang/Desktop/github/Bioinformatics_learn/data/test.fastq | \
  awk '{if(NR%4 == 1){print ">" substr($0, 2)}}{if(NR%4 == 2){print}}' 
