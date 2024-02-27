#!/bin/bash

# Load required modules
source config.sh

variantDir=$1
variantFileName=$2
outputDir=$3

# Download the ENCODE datasets
features=("TF+ChIP-seq" "Histone+ChIP-seq" "DNase-seq" "Mint-ChIP-seq" "ATAC-seq" "eCLIP" "ChIA-PET" "GM+DNase-seq")
for feature in ${features[@]}; do
cd $download_dir

#gunzip ${feature}_feature+anno.sorted.bed.gz

zcat ${feature}_feature+anno.sorted.bed.gz | bedtools intersect -wa -wb -a stdin -b ${variantDir}${variantFileName} -sorted > ${feature}.final.bed

#bedtools intersect -wa -wb -a ${feature}_feature+anno.sorted.bed -b ${variantDir}${variantFileName} -sorted > ${feature}.final.bed

wait

cd $working_dir
python reformat_encode.py $feature $download_dir $outputDir

wait

cd $download_dir

#gzip ${feature}_feature+anno.sorted.bed
rm ${feature}.final.bed  ${feature}.bed; done
