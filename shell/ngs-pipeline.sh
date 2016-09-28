#!/bin/bash

export CF3=$HOME/canfam3
export RESULTS=$HOME/fastq2vcf_runs
export UPLOADS=$HOME/uploads
export PIPELINE_HOME=$HOME/git/NGS-Pipeline/shell
SAMPLE=$1

echo Starting NGS Pipeline for $SAMPLE...

cd $RESULTS/$SAMPLE

if [ ! -e logs ]
then
	mkdir logs
fi

## Convert chunked FASTQ files to aligned SAM files...
qsub -V -t 1-3 -N ${SAMPLE}.fastq2bam ${PIPELINE_HOME}/step1-fastq2sam.sh ${SAMPLE}
qsub -V -t 1-3 -hold_jid ${SAMPLE}.fastq2bam -N ${SAMPLE}.bamEdit ${PIPELINE_HOME}/step2-bamEdit.sh ${SAMPLE}

## Convert chunked FASTQ files to aligned BAM files (via SAM)...
#qsub -V -t 1-3 -N ${SAMPLE}.fastq2bam ${PIPELINE_HOME}/step1-fastq2bam.sh ${SAMPLE}