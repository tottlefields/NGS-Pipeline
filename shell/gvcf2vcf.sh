#!/bin/bash -l

#$ -b y
#$ -cwd
#$ -pe smp 2
#$ -o /tmp/logs/gvcf2vcf.$JOB_ID.out
#$ -e /tmp/logs/gvcf2vcf.$JOB_ID.out
#$ -m ae

today=$(date +"%Y_%m_%d")
count=$(wc -l gVCF_files.list | cut -f 1 -d' ')

vcf_file="../${today}-${count}samples.vcf"
echo "Creating new VCF file: ${vcf_file}"

java -jar $GATK -T GenotypeGVCFs -R $CF3/canfam3.fasta -nt 2 -S STRICT -V gVCF_files.list -o ${vcf_file}

# bwa mem -M -t 4 ${CF3}/canfam3.fasta ${UPLOADS}/BC_29772/BC_29772_R1_003.fastq.gz ${UPLOADS}/BC_29772/BC_29772_R2_003.fastq.gz > ${RESULTS}/BC_29772/BC_29772_aligned_003.sam
