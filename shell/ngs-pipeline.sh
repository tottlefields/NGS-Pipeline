#!/bin/bash

export CF3=$HOME/canfam3/ensembl
export RESULTS=$HOME/fastq2vcf_runs
export UPLOADS=$HOME/uploads
export PIPELINE_HOME=$HOME/git/NGS-Pipeline/shell
export ENSEMBL=86
export PICARD_JAVA_OPTS=' -Xmx4g -Djava.io.tmpdir=${HOME}/javatmpdir'
<<<<<<< HEAD
export SAM_COUNT=3
=======
export FQ_COUNT=3
>>>>>>> branch 'develop' of https://github.com/tottlefields/NGS-Pipeline.git
SAMPLE=$1

echo Starting NGS Pipeline for $SAMPLE...

cd $RESULTS/$SAMPLE

if [ ! -e logs ]
then
	mkdir logs
fi

## Convert chunked FASTQ files to aligned SAM files...
<<<<<<< HEAD
qsub -V -t 1-${SAM_COUNT} -N ${SAMPLE}.fastq2sam ${PIPELINE_HOME}/step1-fastq2sam.sh ${SAMPLE}
qsub -V -t 1-${SAM_COUNT} -hold_jid ${SAMPLE}.fastq2sam -N ${SAMPLE}.sam2bam ${PIPELINE_HOME}/step2-sam2bam.sh ${SAMPLE}
=======
qsub -V -t 1-${FQ_COUNT} -N ${SAMPLE}.fastq2sam ${PIPELINE_HOME}/step1-fastq2sam.sh ${SAMPLE}
qsub -V -t 1-${FQ_COUNT} -hold_jid ${SAMPLE}.fastq2sam -N ${SAMPLE}.sam2bam ${PIPELINE_HOME}/step2-sam2bam.sh ${SAMPLE}

qsub -V -hold_jid ${SAMPLE}.sam2bam -N ${SAMPLE}.bam ${PIPELINE_HOME}/step3-bam.sh ${SAMPLE}
>>>>>>> branch 'develop' of https://github.com/tottlefields/NGS-Pipeline.git

## Convert chunked FASTQ files to aligned BAM files (via SAM)...
#qsub -V -t 1-3 -N ${SAMPLE}.fastq2bam ${PIPELINE_HOME}/step1-fastq2bam.sh ${SAMPLE}
