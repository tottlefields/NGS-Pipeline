#!/bin/bash -l

#$ -b y
#$ -cwd
#$ -pe smp 4
#$ -o fastq2sam.$TASK_ID.out
#$ -e fastq2sam.$TASK_ID.err

module load apps/bwa
module load apps/picard

module add apps/bwa
module add apps/picard

SAMPLE=$1
ID=$(printf "%03d\n" $SGE_TASK_ID)

if [ ! -e $RESULTS/$SAMPLE/$SAMPLE\_aligned_$ID.sam ]
then
        bwa mem -M -t 4 $CF3/canfam3.fasta $UPLOADS/$SAMPLE/$SAMPLE\_R1_$ID.fastq.gz $UPLOADS/$SAMPLE/$SAMPLE\_R2_$ID.fastq.gz > $RESULTS/$SAMPLE/$SAMPLE\_aligned_$ID.sam
fi
