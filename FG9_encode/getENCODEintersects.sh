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

#tail -n +2  ${1}${2}_results_encode_appended.txt >  ${1}${2}_results_encode_appended.tmp
#sort -k 1,1 -k2,2n ${1}${2}_results_encode_appended.tmp |  awk -F"\t" '{ $2 = int($2); $3 = int($3); print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' > ${1}${2}_results_encode.sorted.bed
#rm ${1}${2}_results_encode_appended.tmp
bedtools intersect -wa -wb -a ${1}${2}_results_encode.sorted.bed -b $3 -sorted  | awk -F"\t" '{print $10"\t"$11"\t"$12"\t"$13"\t"$14"\t"$15"\t"$16"\t"$5"\t"$6"\t"$7"\t"$8"\t"$4}' | uniq > ${1}${2}_intersects.bed > ${1}${2}_intersects.bed 


#rm  ${1}${2}_results_encode.sorted.bed
