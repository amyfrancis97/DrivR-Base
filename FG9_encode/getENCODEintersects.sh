#!/bin/bash
#SBATCH --job-name=getEncodeIntersects
#SBATCH --partition=mrcieu,short,test,compute
#SBATCH --mem=180G
#SBATCH --time=5-00:00:0
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG9_encode
#SBATCH --account=sscm013903

# Load bedtools
module load apps/bedops/2.4.38 apps/bedtools/2.30.0
module load apps/bcftools apps/samtools/1.9 apps/tabix/0.2.5 lib/htslib/1.10.2-gcc

#gunzip ${1}${2}_results_encode_appended.txt.gz
#tail -n +2  ${1}${2}_results_encode_appended.txt >  ${1}${2}_results_encode_appended.tmp
#gzip ${1}${2}_results_encode_appended.txt
#sort -k 1,1 -k2,2n ${1}${2}_results_encode_appended.tmp > ${1}${2}_results_encode.sorted.bed
#rm ${1}${2}_results_encode_appended.tmp
bedtools intersect -wa -wb -a ${1}${2}_results_encode.sorted.bed -b $3 -sorted | awk -F"\t" '{print $9"\t"$10"\t"$11"\t"$12"\t"$13"\t"$14"\t"$15"\t"$5"\t"$6"\t"$7"\t"$8"\t"$4}' | uniq > ${1}${2}_intersects.bed
#rm  ${1}${2}_results_encode.sorted.bed
