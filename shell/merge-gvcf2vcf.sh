#!/bin/bash

export GATK=$HOME/gatk/GenomeAnalysisTK.jar
export GVCF_HOME=$HOME/data/gVCF_files
export PIPELINE_HOME=$HOME/git/NGS-Pipeline/shell
export CF3=$HOME/canfam3/

echo Merging all gVCF files in $GVCF_HOME into new VCF File...
cd $GVCF_HOME

if [ ! -e /tmp/logs ]; then
	mkdir /tmp/logs
fi

## Run GATK to merge all gVCF files in a given directory to a new VCF file...
qsub -M ${EMAIL} -V -N gvcf2vcf ${PIPELINE_HOME}/gvcf2vcf.sh

