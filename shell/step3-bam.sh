#!/bin/bash -l

#$ -b y
#$ -cwd
#$ -l h_vmem=8G
#$ -o logs/bam.out
#$ -e logs/bam.err

module load apps/picard
module load apps/samtools
module add apps/picard
module add apps/samtools

samtools merge ${SAMPLE}.raw.bam ${SAMPLE}_*.bam
picard SortSam I=${SAMPLE}.raw.bam O=${SAMPLE}.sorted.bam SORT_ORDER=coordinate
picard MarkDuplicates I=${SAMPLE}.sorted.bam O=${SAMPLE}.bam VALIDATION_STRINGENCY=SILENT CREATE_INDEX=true M=MarkDuplicates_metrics.out