#!/bin/bash -l

#$ -b y
#$ -cwd
#$ -l h_vmem=8G
#$ -o logs/sam2bam.$TASK_ID.out
#$ -e logs/sam2bam.$TASK_ID.err

module load apps/picard
module load apps/samtools
module add apps/picard
module add apps/samtools

SAMPLE=$1
ID=$(printf "%03d\n" $SGE_TASK_ID)

if [ -f ${RESULTS}/${SAMPLE}/${SAMPLE}_${ID}.sam ]; then
	samtools view -b -S -o ${RESULTS}/${SAMPLE}/${SAMPLE}_${ID}.bam ${RESULTS}/${SAMPLE}/${SAMPLE}_${ID}.sam
fi

picard AddOrReplaceReadGroups I=${SAMPLE}_${ID}.bam O=RG_${SAMPLE}_${ID}.bam RGID=${SAMPLE} RGLB=canfam3 RGPL='ILLUMINA' RGPU=${SAMPLE} RGSM=${SAMPLE} 
picard ValidateSamFile I=RG_${SAMPLE}_${ID}.bam O=VAL_${SAMPLE}_${ID}.out MODE=SUMMARY


bam_size=$(wc -c < ${RESULTS}/${SAMPLE}/${SAMPLE}_${ID}.bam)
#if [ $bam_size -ge 50000000 ]; then
#	rm - rf ${RESULTS}/${SAMPLE}/${SAMPLE}_${ID}.sam
#fi


# samtools view -b -S -o BC_29772_aligned_003.bam BC_29772_aligned_003.sam
# picard AddOrReplaceReadGroups I=BC_29772_003.bam O=RG_BC_29772_003.bam RGID=BC_29772 RGLB=canfam3 RGPL='ILLUMINA' RGPU=BC_29772 RGSM=BC_29772 
# picard ValidateSamFiles I=RG_BC_29772_003.bam O=VAL_BC_29772_003.out MODE=SUMMARY
