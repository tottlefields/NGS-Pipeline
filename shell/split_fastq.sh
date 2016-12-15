#!/bin/bash

export FASTQ=/geneticsdata/fastq_files/
SAMPLE=$1

cd ${FASTQ}
mkdir ${SAMPLE}

for f in `ls *${SAMPLE}*fastq*`; do 
	echo $f;
	FQ_FILE=`cut -f 1 -d '.' $f`
	echo zcat $f | split -l 4000000 --additional-suffix=".fastq" --numeric-suffixes=1 --suffix-length=3 --filter='gzip > $FILE.gz' - ${FASTQ}/${SAMPLE}/${FQ_FILE}_
done

echo ${SAMPLE} fastq files have been aplit into a new directory - ${FASTQ}/${SAMPLE};
echo;

#zcat ../BC_29772_R1.fastq.gz | split -l 4000000 --additional-suffix=".fastq" --numeric-suffixes=1 --suffix-length=3 --filter='gzip > $FILE.gz' - BC_29772_R1_
