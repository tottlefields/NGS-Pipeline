#!/bin/bash -l

#$ -b y
#$ -cwd
#$ -pe smp 4
#$ -o logs/fastq2bam.$TASK_ID.out
#$ -e logs/fastq2bam.$TASK_ID.err

module load apps/bwa
module load apps/samtools
module load apps/picard
module add apps/bwa
module add apps/samtools
module add apps/picard

SAMPLE=$1
ID=$(printf "%03d\n" $SGE_TASK_ID)

if [ ! -e ${RESULTS}/${SAMPLE}/${SAMPLE}_${ID}.bam ]
then
        bwa mem -M -t 4 ${CF3}/canfam3.fasta ${UPLOADS}/${SAMPLE}/${SAMPLE}_R1_${ID}.fastq.gz ${UPLOADS}/${SAMPLE}/${SAMPLE}_R2_${ID}.fastq.gz > ${RESULTS}/${SAMPLE}/${SAMPLE}_${ID}.sam
        samtools view -b -S -o ${RESULTS}/${SAMPLE}/${SAMPLE}_${ID}.bam ${RESULTS}/${SAMPLE}/${SAMPLE}_${ID}.sam
fi

# bwa mem -M -t 4 ${CF3}/canfam3.fasta ${UPLOADS}/BC_29772/BC_29772_R1_003.fastq.gz ${UPLOADS}/BC_29772/BC_29772_R2_003.fastq.gz > ${RESULTS}/BC_29772/BC_29772_aligned_003.sam
# samtools view -b -S -o BC_29772_aligned_003.bam BC_29772_aligned_003.sam

bam_size=$(wc -c <" ${SAMPLE}_${ID}.bam")
if [ $bam_size -le 50000000 ]
then
	rm - rf ${SAMPLE}_${ID}.sam
fi


if [ ! -e ${RESULTS}/${SAMPLE}/RG_${SAMPLE}_${ID}.bam ]
then
	picard AddOrReplaceReadGroups I=${SAMPLE}_${ID}.bam O=RG_${SAMPLE}_${ID}.bam RGID=${SAMPLE} RGLB=canfam3 RGPL='ILLUMINA' RGPU=${SAMPLE} RGSM=${SAMPLE} 
	picard ValidateSamFiles I=RG_${SAMPLE}_${ID}.bam O=VAL_${SAMPLE}_${ID}.out MODE=SUMMARY
	samtools flagstat RG_${SAMPLE}_${ID}.bam > flagstat_${SAMPLE}_${ID}.out
fi

# picard AddOrReplaceReadGroups I=BC_29772_aligned_003.bam O=RG_BC_29772_003.bam RGID=BC_29772 RGLB=canfam3 RGPL='ILLUMINA' RGPU=BC_29772 RGSM=BC_29772 
# picard ValidateSamFiles I=RG_BC_29772_003.bam O=VAL_BC_29772_003.out MODE=SUMMARY
# samtools flagstat RG_BC_29772_003.bam > flagstat_BC_29772_003.out
