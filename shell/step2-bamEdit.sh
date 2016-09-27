#!/bin/bash -l

#$ -b y
#$ -cwd
#$ -o logs/bamEdit.$TASK_ID.out
#$ -e logs/bamEdit.$TASK_ID.err

module load apps/picard
module load apps/samtools
module add apps/picard
module add apps/samtools

SAMPLE=$1
ID=$(printf "%03d\n" $SGE_TASK_ID)


#Check to see that bam file genereated in step 1 in >50MB
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
