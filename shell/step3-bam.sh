#!/bin/bash -l

#$ -b y
#$ -cwd
#$ -l h_vmem=8G
#$ -o logs/bam.out
#$ -e logs/bam.err
#$ -m ae

if [ $START_STEP -gt 3  ]; then
	exit
fi

module load apps/picard
module load apps/samtools

SAMPLE=$1
source ${RESULTS}/${SAMPLE}.cfg

file_count=$(ls -1 RG_${SAMPLE}_*.bam | wc -l)
if [ $file_count -gt 0 ]; then
	echo "Merging BAM files"
	samtools merge ${SAMPLE}.raw.bam RG_${SAMPLE}_*.bam
fi

### if size of the merged bam file >= 200MB then delete corresponding bam files
bam_size1=$(wc -c < ${RESULTS}/${SAMPLE}/${SAMPLE}.raw.bam)
if [ $bam_size1 -ge 200000000 ]; then
	echo "Deleting ${RESULTS}/${SAMPLE}/RG_${SAMPLE}_*.bam"
	rm -rf ${RESULTS}/${SAMPLE}/RG_${SAMPLE}_*.bam
fi


picard SortSam I=${SAMPLE}.raw.bam O=${SAMPLE}.sorted.bam SORT_ORDER=coordinate

### if size of the sorted bam file >= 10% of raw bam then delete file
bam_size2=$(wc -c < ${RESULTS}/${SAMPLE}/${SAMPLE}.sorted.bam)
if [ $bam_size2 -ge $(( ${bam_size1}/10 )) ]; then
	echo "Deleting ${RESULTS}/${SAMPLE}/${SAMPLE}.raw.bam"
	rm -rf ${RESULTS}/${SAMPLE}/${SAMPLE}.raw.bam
	picard MarkDuplicates I=${SAMPLE}.sorted.bam O=${SAMPLE}.bam VALIDATION_STRINGENCY=SILENT CREATE_INDEX=true M=MarkDuplicates_metrics.out
fi


### if size of the bam file >= 10% of sorted bam then delete file
bam_size3=$(wc -c < ${RESULTS}/${SAMPLE}/${SAMPLE}.bam)
if [ $bam_size3 -ge $(( ${bam_size2}/10 )) ]; then
	echo "Deleting ${RESULTS}/${SAMPLE}/${SAMPLE}.sorted.bam"
	rm -rf ${RESULTS}/${SAMPLE}/${SAMPLE}.sorted.bam
fi

