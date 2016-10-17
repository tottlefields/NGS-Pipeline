#!/bin/bash -l

#$ -b y
#$ -cwd
#$ -pe smp 4
#$ -o logs/fastq2sam.$TASK_ID.out
#$ -e logs/fastq2sam.$TASK_ID.err
#$ -m ae

if [ $START_STEP -gt 1  ]; then
	exit
fi

module load apps/bwa
source ${RESULTS}/${SAMLPE}.cfg

SAMPLE=$1
ID=$(printf "%03d\n" $SGE_TASK_ID)

if [ ! -e ${RESULTS}/${SAMPLE}/${SAMPLE}_${ID}.sam ]
then
        bwa mem -M -t 4 ${CF3}/canfam3.fasta ${UPLOADS}/${SAMPLE}/${SAMPLE}_R1_${ID}.fastq.gz ${UPLOADS}/${SAMPLE}/${SAMPLE}_R2_${ID}.fastq.gz > ${RESULTS}/${SAMPLE}/${SAMPLE}_${ID}.sam
fi

# bwa mem -M -t 4 ${CF3}/canfam3.fasta ${UPLOADS}/BC_29772/BC_29772_R1_003.fastq.gz ${UPLOADS}/BC_29772/BC_29772_R2_003.fastq.gz > ${RESULTS}/BC_29772/BC_29772_aligned_003.sam
