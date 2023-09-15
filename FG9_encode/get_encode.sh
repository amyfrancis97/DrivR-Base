#!/bin/bash

# Load required modules
source config.sh
source ${module_dependencies_loc}module_dependencies.sh

variantDir=$1
variantFileName=$2
outputDir=$3

# Download the ENCODE datasets
#features=("DNase-seq" "Mint-ChIP-seq" "ATAC-seq" "eCLIP" "ChIA-PET" "GM+DNase-seq")
features=("TF+ChIP-seq" "Histone+ChIP-seq")
for feature in ${features[@]}; do
#cd $working_dir

# Run python script to download all peak bedGraph files for each feature
#python downloadEncode.py $feature $download_dir

#wait

#cd $download_dir

# Convert the file from bedGraph to bed
#for i in *${feature}.bigBed; do bigBedToBed $i "${i%.bigBed}.bed"; done

#rm *".${feature}.bigBed"

# Add the accession as a column in the file to query information later on
#for file in *${feature}.bed; do
#filename=$(echo "$file" | sed 's/+/_/g' | cut -d. -f1)
#awk -v OFS='\t' -v val="$filename" '{$(NF+1) = val} 1' $file > ${file}.tmp;
#done

#rm *."${feature}.bed" 

# Combine the files
#cat *${feature}.bed.tmp > ${feature}.bed 

#rm *."${feature}.bed.tmp"

#cd $working_dir

# Merge annotation and peaks
#python addAnnotations.py $feature $download_dir

#wait

echo $download_dir
cd $download_dir

pwd

# Remove all of the bed and bigBed files
rm *"${feature}_fileInfo.txt"

tail -n +2  ${feature}_feature+anno.txt > ${feature}_feature+anno.tmp
sort -k 1,1 -k2,2n ${feature}_feature+anno.tmp |  awk -F"\t" '{ $2 = int($2); $3 = int($3); print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\t"$13"\t"$14"\t"$15"\t"$16}' > ${feature}_feature+anno.sorted.bed
rm ${feature}_feature+anno.tmp

bedtools intersect -wa -wb -a ${feature}_feature+anno.sorted.bed -b ${variantDir}${variantFileName} -sorted > ${feature}.final.bed

head ${feature}_feature+anno.sorted.bed
head ${variantDir}${variantFileName}

wait

cd $working_dir
python reformat_encode.py $feature $download_dir $outputDir

wait

cd $download_dir; done
rm ${feature}.final.bed  ${feature}.bed; done
