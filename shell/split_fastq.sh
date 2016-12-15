#!/bin/bash

export FASTQ=/geneticsdata/fastq_files/
SAMPLE=$1

cd ${FASTQ}
mkdir ${SAMPLE}

for f in `ls *${SAMPLE}*fastq*`; do 
	echo $f; 
done


#zcat ../BC_29772_R1.fastq.gz | split -l 4000000 --additional-suffix=".fastq" --numeric-suffixes=1 --suffix-length=3 --filter='gzip > $FILE.gz' - BC_29772_R1_
