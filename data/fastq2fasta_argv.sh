#/bin/bash

fastq=$1 

less $fastq | \
  awk '{if(NR%4 == 1){print ">" substr($0, 2)}}{if(NR%4 == 2){print}}' 
