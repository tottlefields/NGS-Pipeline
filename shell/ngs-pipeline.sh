#!/bin/bash

export RESULTS=$HOME/fastq2vcf_runs
export PIPELINE_HOME=$HOME/git/NGS-Pipeline/shell
SAMPLE=$1
STEP=1

if [ "$#" -ge 2 ]; then
	STEP=$2
fi
export START_STEP=${STEP}

if [ ! -f ${RESULTS}/${SAMPLE}.cfg ]; then
	echo "You need to create a configuration file to run the NGS Pipeline for ${SAMPLE} - ${RESULTS}/${SAMPLE}.cfg"
	exit
fi

echo Starting NGS Pipeline for $SAMPLE...
source ${RESULTS}/${SAMPLE}.cfg

if [ ! -e $RESULTS/$SAMPLE ]; then
	mkdir $RESULTS/$SAMPLE
fi

cd $RESULTS/$SAMPLE

if [ ! -e logs ]; then
	mkdir logs
fi

## Convert chunked FASTQ files to aligned SAM files...
qsub -M ${EMAIL} -d ${RESULTS}/${SAMPLE} -V -t 1-${FQ_COUNT} -N ${SAMPLE}.fastq2sam ${PIPELINE_HOME}/step1-fastq2sam.sh ${SAMPLE}
qsub -M ${EMAIL} -d ${RESULTS}/${SAMPLE} -V -t 1-${FQ_COUNT} -hold_jid_ad ${SAMPLE}.fastq2sam -N ${SAMPLE}.sam2bam ${PIPELINE_HOME}/step2-sam2bam.sh ${SAMPLE}

qsub -M ${EMAIL} -d ${RESULTS}/${SAMPLE} -V -hold_jid ${SAMPLE}.sam2bam -N ${SAMPLE}.bam ${PIPELINE_HOME}/step3-bam.sh ${SAMPLE}

